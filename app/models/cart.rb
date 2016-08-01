class Cart
  include Mongoid::Document
  include HasProductSummaries

  delegate :empty?, to: :cart_skus

  # If the cart is set up to display the shipping costs
  # for its current content, you will have to make a quote
  # request to BorderGuru.calculate_quote whenever its
  # content changes. Save the returned quote id in this
  # field and pass it to BorderGuru.create_shipping
  # (probably by intermediary of the Order model),
  # when it comes to create the shipment for the final
  # order.
  field :border_guru_quote_id, type: String
  field :submerchant_id, type: String
  field :shipping_cost, type: Float
  field :tax_and_duty_cost, type: Float

  # When the admin changes the properties of a product,
  # the product in the cart has to change as well. Therefore
  # a "has_many" would be the right association – if it was not
  # for one property that has to be kept in the association
  # between Cart and Product:
  # quantity_in_cart. So quantity_in_cart is kept within
  # CartProduct (the proxy embedded in Cart), while the
  # CartProduct itsself "belongs_to" the Product
  # (not embedded/"frozen", therefore remaining independent).
  embeds_many :cart_skus
  summarizes sku_list: :cart_skus, by: :quantity_in_cart

  def total_price_in_yuan
    sum = (shipping_cost + tax_and_duty_cost + cart_skus.inject(0) { |sum, s| sum += (s.price * s.quantity_in_cart) }) * Settings.instance.exchange_rate_to_yuan
    sum.round(2)
  end

end
