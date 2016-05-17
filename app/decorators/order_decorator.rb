class OrderDecorator < Draper::Decorator

  delegate_all
  decorates :order

  def total_price_in_currency(currency_code)
    "#{object.total_price} #{currency_code}"
  end

  def current_cart
    cart = Cart.new

    order_items.each do |i|
      cart.add(i.sku, i.quantity)
    end


    BorderGuru.calculate_quote(
        cart: cart,
        shop: order_items.,
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )
  end
end