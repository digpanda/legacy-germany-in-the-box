# the layer between the controller and the API / model
# for everything linked with the BorderGuruApi
class BorderGuruApiHandler < BaseService

  attr_reader :order, :shop

  def initialize(order)
    @order = order
    @shop = order.shop
  end

  def trash!
    get_shipping
    return_with(:success)
    # too much things can happen inside our system
    # so we catch the exception globally
  rescue StandardError => exception
    return_with(:error, exception)
  end

  private

  # the library is made as it update the order model automatically
  def get_shipping
    BorderGuru.get_shipping(
        order: order,
        shop: shop,
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )
  end

end
