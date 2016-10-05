# change and retrieve current order from session / database
# this is linked to the cart system
class CurrentOrderHandler < BaseService

  attr_reader :shop, :session, :current_user

  def initialize(session, current_user, shop)
    @session = session
    @shop = shop
    @current_user = current_user
    safe_recovery!
  end

  def process

    # when we first call order it either retrieve a current existing order
    # or create a new one
    # we will avoid calling BorderGuru for empty orders (like new ones)
    if order.order_items.count > 0
      refresh_with_quote_api!
    end

    setup_user_order!
    if current_user
      if current_user.decorate.customer?
        setup_user_order!
      else
        # remove_order! NOTE : i don't think it's used anymore since the whole system depend on logged-in customer now -> need to be tested and checked
      end
    end
    order
  end

  def order
    @order ||= begin
      setup_session!
      if session[:order_shop_ids]["#{shop.id}"]
        Order.find(session[:order_shop_ids]["#{shop.id}"])
      else
        Order.new
      end
    end
  end

  def store(order)
    setup_session!
    session[:order_shop_ids]["#{shop.id}"] = "#{order.id}"
  end

  private

  def remove_order!
    order.order_items.delete_all
    order.delete
  end

  # we consider the current user as the order user
  # if it wasn't attributed already
  def setup_user_order!
    unless order.user
      order.user = current_user
      order.save
    end
  end

  def setup_session!
    session[:order_shop_ids] ||= {}
  end

  # make sure all the datas are current and valid within the session
  def safe_recovery!
    return if session[:order_shop_ids].nil?
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

  def refresh_with_quote_api!
    BorderGuru.calculate_quote(
    order: order,
    shop: order.shop,
    country_of_destination: ISO3166::Country.new('CN'),
    currency: 'EUR'
    )
  rescue Net::ReadTimeout => e
    logger.fatal "Failed to connect to Borderguru: #{e}"
    return
  end

end
