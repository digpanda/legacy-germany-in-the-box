# change and retrieve current orders from session / database
# this is linked to the cart system itself (with session + database)
class CartManager < BaseService

  attr_reader :request, :session, :user

  def initialize(request, user)
    @request = request
    @session = request.session
    @user = user
  end

  # the current cart can be taken from session
  # or from the database
  # if at any point the `user` is defined
  # the session_cart will be converted
  # into a registered user cart
  def current_cart
    @current_cart ||= begin
      if user
        return filled_user_cart! if user.cart
        session_to_user_cart!
      else
        session_cart
      end
    end
  end

  def order(shop:)
    current_cart.orders.where(shop: shop).first || fresh_order(shop, user)
  end

  def orders
    current_cart.orders
  end

  def store(order)
    current_cart.orders << order
    current_cart.save
  end

  # we unlink all the orders from the cart
  # NOTE : it doesn't mean we remove the orders themselves
  def empty!
    current_cart.orders = []
    current_cart.save
  end

  # we unlink the bought or cancelled orders from the cart
  def refresh!
    current_cart.orders.each do |order|
      if order.bought_or_cancelled?
        order.cart = nil
        order.save
      end
    end
  end

  # we get the total product numbers from the cart orders
  def products_number
    @products_number ||= begin
      orders.inject(0) do |acc, order|
        acc += order.decorate.displayable_total_quantity
      end
    end
  end

  private

  def session_to_user_cart!
    session_cart.update(user: user)
    ensure_orders_ownership!
    user.cart
  end

  def filled_user_cart!
    if user.cart.orders.count == 0
      user.cart.orders = session_cart.orders
      user.cart.save
      ensure_orders_ownership!
    end
    user.cart
  end

  def session_cart
    @session_cart ||= begin
      ensure_session_cart!
      Cart.find(session[:current_cart])
    end
  end

  def ensure_orders_ownership!
    user.cart.orders.where(user: nil).each do |order|
      order.user = user
      if user.parent_referrer
        order.referrer = user.parent_referrer
        order.referrer_origin = :user
      end
      order.save
    end
  end

  def ensure_session_cart!
    session[:current_cart] = Cart.create.id unless session[:current_cart]
  end

  # NOTE : sometimes the parent referrer won't be defined
  # because the order is started anonymously
  def fresh_order(shop, user)
    Order.new(cart: current_cart, shop: shop, user: user, referrer: user&.parent_referrer, referrer_origin: :user, logistic_partner: Setting.instance.logistic_partner, exchange_rate: Setting.instance.exchange_rate_to_yuan)
  end

end
