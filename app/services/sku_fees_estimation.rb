# right now BorderGuru doesn't provide us with an estimation per item
# we have to emulate a whole order containing
# only one item to get the fee
class SkuFeesEstimation < BaseService

  API_RESULT = [:taxAndDutyCost, :shippingCost]

  include ErrorsHelper

  attr_reader :sku

  def initialize(sku)
    @sku = sku
  end

  # call BorderGuru API
  # with the correct datas
  def provide
    return_with(:success, response.result.select(&api_filter))
  rescue StandardError => exception
    warn_developers(StandardError.new, "Issue while trying to get the skus fees estimation")
    return_with(:error, exception)
  ensure
    clean
  end

  private

  def api_filter
    -> (key, value) {
      API_RESULT.include?(key)
    }
  end

  def response
    @response ||= BorderGuru.calculate_quote(order: order)
  end

  # we prepare the order
  # and add the sku in it
  def order
    @order ||= begin
      OrderMaker.new(Order.new).add(sku, 1).data[:order].tap do |order|
        # we have to manually add the shop
        # this could be better done but for now it works well
        # refer to `add_product` method to see (moved to guest/order_items#create)
        # the other system to place orders
        order.shop_id = sku.product.shop.id
        order.save
      end
    end
  end

  # we clean up the order
  # after the API replied
  def clean
    order.order_items.delete_all
    order.delete
  end

end
