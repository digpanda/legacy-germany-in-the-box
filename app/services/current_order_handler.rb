# change and retrieve current order from session / database
# this is linked to the cart system
class CurrentOrderHandler < BaseService

  attr_reader :shop, :session

  def initialize(session, shop)
    @session = session
    @shop = shop
    safe_recovery!
  end

  def retrieve
    setup_session!
    if session[:order_shop_ids]["#{shop.id}"]
      Order.find(session[:order_shop_ids]["#{shop.id}"])
    end
  end

  private

  def setup_session!
    session[:order_shop_ids] ||= {}
  end

  # make sure all the datas are current and valid within the session
  def safe_recovery!
    session[:order_shop_ids] = session[:order_shop_ids].map do |shop_id, order_id|
      shop = Shop.where(id: shop_id).first
      order = Order.where(id: order_id).first
      unless shop.nil? || order.nil?
        unless order.status == :success # we remove the successful orders from the cart
          {"#{shop.id}" => "#{order.id}"}
        end
      end
    end.compact.inject(&:update)
  end


end
