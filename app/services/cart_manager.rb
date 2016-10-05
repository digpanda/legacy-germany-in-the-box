# change and retrieve current orders from session / database
# this is linked to the cart system itself (with session + database)
class CartManager < BaseService

  attr_reader :shop, :session, :current_user

  def initialize(session, current_user)
    @session = session
    @current_user = current_user
    safe_recovery!
    setup_session!
  end

  # try to get an order
  # if it doesn't work it'll make a new one which's empty
  def order(shop)
    CartManager::OrderHandler.new(session, current_user, shop).recover.order
  end

  # get all the orders we have in the cart
  def orders
    # this could be improved (we have to find shop all the time, etc.)
    @orders ||= session[:order_shop_ids].keys.compact.map { |shop_id| [shop_id, order(Shop.find(shop_id))] }.to_h
  end

  # store a new order in the cart
  # it will overwrite any order that was present within the session
  # for the same shop
  def store(order)
    session[:order_shop_ids]["#{order.shop.id}"] = "#{order.id}"
  end

  # empty all orders from the cart
  # NOTE : currently not in use in our system
  def empty!
    session[:order_shop_ids] = {}
  end

  private

  # create the session variable
  # to avoid nil return so we can iterate it even if empty
  def setup_session!
    session[:order_shop_ids] ||= {}
  end

  # make sure all the datas are current and valid within the session
  # it will remove all the orders / shops that aren't valid anymore
  # which would occur when someone remove them for some reason
  def safe_recovery!
    return if session[:order_shop_ids].nil?
    session[:order_shop_ids] = session[:order_shop_ids].map do |shop_id, order_id|
      shop = Shop.where(id: shop_id).first
      order = Order.where(id: order_id).first
      unless shop.nil? || order.nil?
        unless order.status == :success # we remove the successful orders from the cart
          {"#{order.shop.id}" => "#{order.id}"}
        end
      end
    end.compact.inject(&:update)
  end

end
