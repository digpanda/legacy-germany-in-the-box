# manage the checkout preparation for the checkout_controller
# make sure everything is on place and prepare the order itself
class CheckoutReady < BaseService

  attr_reader :session, :user, :order, :address

  class << self
    def current_order!(session, order)
      session[:current_checkout_order] = order.id
    end
  end

  def initialize(session, user, order, address)
    @session = session
    @user = user
    @order = order
    @address = address
  end

  def perform!

    # we update the delivery address before everything
    # this will be used to check the limit reach
    update_addresses!

    # make sure the customer has valid informations for checkout
    unless user.valid_for_checkout?
      return return_with(:error, "Invalid customer for checkout.")
    end

    # did he reach today's limit ?
    if today_limit?
      return return_with(:error, I18n.t('edit_order.override_maximal_total', total: Setting.instance.max_total_per_day, currency: Setting.instance.platform_currency.symbol))
    end

    # are all products available for real ? (inventory check)
    unless products_available?
      return return_with(:error, I18n.t('checkout.not_all_available', :product_name => products_available[:unavailable_sku].product.name, :option_names => products_available[:unavailable_sku].option_names.join(', ')))
    end

    # did he reach the minimum shop requirement in term of order amount ?
    unless minimum_shop?
      return return_with(:error, I18n.t('checkout.not_all_min_total_reached', :shop_name => order.shop.name, :total_price => products_available[:total_price].in_euro.to_yuan.display, :currency => Setting.instance.platform_currency.symbol, :min_total => order.shop.min_total.in_euro.to_yuan(exchange_rate: order.exchange_rate).display))
    end

    # let's update for checkout
    unless update_for_checkout!(order)
      return return_with(:error, order.errors.full_messages.join(', '))
    end

    # we don't forget to set the current order as the one
    # we will use in the next steps automatically
    refresh_current_order!
    return_with(:success)

  end

  private

  def refresh_current_order!
    CheckoutReady.current_order!(session, order)
  end

  def update_addresses!
    order.update(shipping_address: nil, billing_address: nil)
    order.update(shipping_address: address.clone, billing_address: address.clone)
  end

  def update_for_checkout!(order)
    order.update({
        :status               => :paying,
        :user                 => user,
      })
  end

  def today_limit?
    BuyingBreaker.new(order).with_address?(order.shipping_address)
  end

  def minimum_shop?
    products_available[:total_price] >= order.shop.min_total
  end

  def products_available?
    products_available[:all]
  end

  def products_available
    @products_available ||= begin

      all_products_available = true
      products_total_price = 0
      sku = nil

      order.order_items.each do |order_item|
        sku = order_item.sku
        sku_origin = order_item.sku_origin

        if sku_origin.enough_stock?(order_item.quantity)
          all_products_available = true
          products_total_price += order_item.total_price
        else
          all_products_available = false
          break
        end
      end

      {
        :all => all_products_available,
        :unavailable_sku => sku,
        :total_price => products_total_price
      }
    end
  end

end
