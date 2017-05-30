class OrderMaker
  class Sku

    attr_reader :order, :sku, :product

    def initialize(order, sku, quantity)
      @order = order
      @sku = sku
      @product = sku.product
    end

    def order_item
      @order_item ||= order.order_items.with_sku(sku).first || fresh_order_item!
    end

    def updatable_order_item?
      order_item.present? && !order_item.locked?
    end

    def available_sku?
      sku.stock_available_in_order?(quantity, order) && sku.enough_stock?(quantity)
    end

    def add
      if updatable_order_item? && available_sku?
        if order_item.inc(quantity: 1)
          return_with(:success, order_item: order_item, msg: success_ok)
        else
          return_with(:error, error: error_not_available)
        end
      end
    end

    private

    def fresh_order_item!
      order.order_items.build.tap do |order_item|
        order_item.quantity = quantity
        order_item.product = product
        order_item.referrer_rate = product.referrer_rate || 0.0
        order_item.quantity = 0 # we will increment this afterwards
        order_item.sku_origin = sku # we don't forget to define the origin
        clone_sku!(order_item) # we clone in a clean way the sku
      end
    end

    def clone_sku!(order_item)
      SkuCloner.new(order_item, sku, :singular).process
    end

    def error_not_available
      I18n.t(:not_all_available, scope: :checkout, product_name: product.name, option_names: sku.display_option_names)
    end

    def success_ok
      I18n.t(:add_product_ok, scope: :edit_order)
    end

  end
end
