# the layer between the controller and the API / model
# for everything linked with the BorderGuruApi
class BorderGuruApiHandler < BaseService

  include ErrorsHelper

  attr_reader :order, :shop

  def initialize(order)
    @order = order
    @shop = order.shop
  end

  # will get the shipping and refresh the order itself
  # too much things can happen inside our system
  # so we catch the exception globally
  def get_shipping!
    BorderGuru.get_shipping(order: order)
    return_with(:success)
  rescue StandardError => exception
    return_with(:error, exception)
  end

end
