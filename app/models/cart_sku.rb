class CartSku
  include Mongoid::Document

  field :quantity_in_cart, type: Integer

  # inverse_of nil because products do not yet need to know
  # whether they are part of a cart (=wrapped by a cart product)
  belongs_to :sku, inverse_of: nil

  PROXIED_FIELDS = Sku.attribute_names +
      %w(duty_category)

  def method_missing(method, *args, &b)
    if PROXIED_FIELDS.include? method.to_s
      sku.send method
    else
      super
    end
  end

  def becomes_order_line_item
    current_order_item = OrderItem.new

    current_order_item.price = sku.price
    current_order_item.quantity = sku.quantity_in_cart
    current_order_item.weight = sku.weight
    current_order_item.product = sku.product
    current_order_item.product_name = sku.product.name
    current_order_item.sku_id = sku.id.to_s
    current_order_item.option_ids = sku.option_ids
    current_order_item.option_names = get_options(sku)

    current_order_item
  end

  private

  def get_options(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      { name: v.name, option: { name: o.name } }
    end
  end
end