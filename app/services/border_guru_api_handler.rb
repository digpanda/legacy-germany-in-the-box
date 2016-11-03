# the layer between the controller and the API / model
# for everything linked with the BorderGuruApi
class BorderGuruApiHandler < BaseService

  attr_reader :order, :shop
  include ErrorsHelper
  
  def initialize(order)
    @order = order
    @shop = order.shop
  end

  def get_shipping!
    # will get the shipping and refresh the order itself
    BorderGuru.get_shipping(
        order: order,
        shop: shop,
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )
    return_with(:success)
    # too much things can happen inside our system
    # so we catch the exception globally
  rescue StandardError => exception
    warn_developers(StandardError.new, "Issue while trying to call get_shipping from BorderGuru")
    return_with(:error, exception)
  end

end
