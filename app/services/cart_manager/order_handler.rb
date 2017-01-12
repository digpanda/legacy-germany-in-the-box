# target one specific order and deal with it inside our cart manager system
# NOTE : you shouldn't access directly (or at least avoid to do so)
# be aware there's no session initializer for the variables manipulated in this class
# if it causes problem, don't hesitate to change this
class CartManager
  class OrderHandler < BaseService

    attr_reader :session, :user, :shop

    def initialize(session, user, shop)
      @session = session
      @user = user
      @shop = shop
    end

    # when we first call order it either retrieve a current existing order
    # or create a new one
    # we will avoid calling BorderGuru for empty orders (like new ones)
    def recover(call_api=true)
      if order.order_items.count > 0
        refresh_with_quote_api! if call_api
      end
      setup_user_order!
      setup_shop_order!
      self
    end

    # create or recover the order from session
    # depends on the shop.id data
    def order
      @order ||= begin
        if session[:order_shop_ids]["#{shop.id}"]
          Order.find(session[:order_shop_ids]["#{shop.id}"])
        else
          # we systematically bind an order to a shop
          Order.new(shop: shop)
        end
      end
    end

    private

    # we consider the current user as the order user
    # if it wasn't attributed already
    def setup_user_order!
      unless order.user
        order.user = user
        order.save
      end
    end

    # sometimes order passing through this don't have any shop assigned
    # we fix it immediately
    def setup_shop_order!
      unless order.shop
        order.shop = shop
        order.save
      end
    end

    # NOTE : this should be moved on one specific location and not called every time
    # it's the same for estimated_taxes etc.
    def refresh_with_quote_api!
      BorderGuru.calculate_quote(order: order)
    rescue BorderGuru::Error, Net::ReadTimeout => e
      raise CartManager::Error, e.message
    end

  end
end
