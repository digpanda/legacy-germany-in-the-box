# the layer between the controller and the API / model
# for everything linked with the BorderGuruApi
class BorderGuruApiHandler < BaseService

  include ErrorsHelper

  attr_reader :order, :shop

  def initialize(order)
    @order = order
    @shop = order.shop
  end

  def calculate_and_get_shipping
    SlackDispatcher.new.borderguru_calculate_error(order) unless calculate_quote.success?
    SlackDispatcher.new.borderguru_get_shipping_error(order) unless get_shipping!.success?
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

  def calculate_quote
    BorderGuru.calculate_quote(order: order)
    return_with(:success)
  rescue StandardError => exception
    return_with(:error, exception)
  end

end
