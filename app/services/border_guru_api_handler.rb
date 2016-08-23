# the layer between the controller and the API / model
# for everything linked with the BorderGuruApi
class BorderGuruApiHandler < BaseService

  attr_reader :order, :shop

  def initialize(order)
    @order = order
    @shop = order.shop
  end

  def link_tracking
    refresh_order_shipping!
    return_with(:success, url: order.border_guru_link_tracking)
  rescue StandardError => exception
    return_with(:error, exception)
  end

  private

  # the library is made as it update the order model automatically
  def refresh_order_shipping!
    BorderGuru.get_shipping(
        order: order,
        shop: shop,
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )
  end

end
