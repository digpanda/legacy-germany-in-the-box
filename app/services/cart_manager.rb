# change and retrieve current orders from session / database
# this is linked to the cart system itself (with session + database)
class CartManager < BaseService

  attr_reader :shop, :session, :user

  def initialize(session, user)
    @session = session
    @user = user
    safe_recovery!
    setup_session!
  end

  # try to get an order
  # if it doesn't work it'll make a new one which's empty
  def order(shop:)
    CartManager::OrderHandler.new(session, user, shop).recover.order
  end

  # get all the orders we have in the cart
  def orders
    @orders ||= session[:order_shop_ids].keys.compact.map do |shop_id|
      order(shop: Shop.find(shop_id))
    end
  end

  # store a new order in the cart
  # it will overwrite any order that was present within the session
  # for the same shop
  # there's a minor validation so we cannot have a bought / cancelled order in the cart
  def store(order)
    if order.bought_or_cancelled?
      order.cart = nil
      order.save
      return false
    end
    unless session[:order_shop_ids].has_key?(order.shop.id.to_s)
      session[:order_shop_ids]["#{order.shop.id}"] = "#{order.id}"
    end
  end

  # empty all orders from the cart
  def empty!
    session[:order_shop_ids] = {}
  end

  # we refresh the cart manager by cleaning it out
  # from successful or cancelled orders
  def refresh!
    safe_recovery!
  end

  def products_number
    @products_number ||= begin
      orders.inject(0) do |acc, shop_order|
        acc += shop_order.decorate.displayable_total_quantity
      end
    end
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
        unless order.bought_or_cancelled?
          {"#{order.shop.id}" => "#{order.id}"}
        end
      end
    end.compact.inject(&:update)
  end

end
