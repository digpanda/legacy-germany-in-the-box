# manage the orders related to simple skus
class OrderMaker
  class SkuHandler < BaseService

    attr_reader :order, :sku, :product, :quantity

    def initialize(order, sku, quantity)
      @order = order
      @sku = sku
      @product = sku.product
      @quantity = quantity
    end

    def add
      raise_error?
      order_item.quantity += quantity
      order_item.save
      save_order!
      return_with(:success, order_item: order_item, message: success_ok)
    rescue OrderMaker::Error => exception
      return_with(:error, error: exception.message)
    end

    private

    def order_item
      @order_item ||= order.order_items.with_sku(sku).first || fresh_order_item!
    end

    def fresh_order_item!
      order.order_items.build.tap do |order_item|
        order_item.product = product
        order_item.referrer_rate = product.referrer_rate || 0.0
        order_item.quantity = 1 # we will increment this afterwards
        order_item.sku_origin = sku # we don't forget to define the origin
        clone_sku!(order_item) # we clone in a clean way the sku
        order_item.save
        order_item.quantity = 0 # we will increment this afterwards
      end
    end

    # the sku in order item is an embedded document which finds its origin
    # in the product sku, this copy follows a complex process to be cleanly cloned
    def clone_sku!(order_item)
      SkuCloner.new(order_item, sku, :singular).process
      order_item.reload # thanks mongo
    end

    def save_order!
      raise OrderMaker::Error, order.errors.full_messages.join(', ') unless order.save
    end

    def raise_error?
      if !valid_quantity?
        raise OrderMaker::Error, error_quantity
      elsif !updatable_order_item?
        raise OrderMaker::Error, error_updatable
      elsif !available_sku?
        raise OrderMaker::Error, error_not_available
      end
    end

    def updatable_order_item?
      order_item.present? && !order_item.locked?
    end

    def available_sku?
      sku.stock_available_in_order?(quantity, order) && sku.enough_stock?(quantity)
    end

    def valid_quantity?
      quantity > 0
    end

    def error_updatable
      "This order has been locked and can't be updated."
    end

    def error_not_available
      I18n.t(:not_all_available, scope: :checkout, product_name: product.name, option_names: sku.display_option_names)
    end

    def error_quantity
      I18n.t(:not_available, scope: :popular_products)
    end

    def success_ok
      I18n.t(:add_product_ok, scope: :edit_order)
    end

  end
end
