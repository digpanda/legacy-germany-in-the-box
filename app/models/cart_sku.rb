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
    product.becomes(OrderLineItem).tap do |oli|
      oli.quantity_ordered = quantity_in_cart
    end
  end
end