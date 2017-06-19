require 'addressable/uri'

class SigninHandler

  include Rails.application.routes.url_helpers

  attr_reader :request, :navigation, :session, :user, :cart_manager

  def initialize(request, navigation, user, cart_manager)
    @request = request
    @navigation = navigation
    @session = request.session
    @user = user
    @cart_manager = cart_manager
  end

  def solve!(refresh:false)
    SlackDispatcher.new.message("SIGNIN HANDLER WAS CALLED `#{request.url}`")
    if user.customer?
      force_chinese!
      handle_past_orders!
      # recover_last_order! TODO : fix that
      return missing_info_customer_account_path(kept_params) if user.missing_info?
      return navigation.force! if navigation.force?
      return customer_referrer_path(kept_params) if user.referrer?

      # NOTE : we remove the code param from the redirect URL
      # because if the user comes from WeChat that would make an infinite loop
      # we can either refresh the current page or go back
      if refresh
        return without_code request.url
      else
        return without_code navigation.back(1)
      end
    end

    # if the person is not a customer
    # he doesn't need any order.
    remove_all_orders!

    if user.shopkeeper?
      force_german!
      return shopkeeper_orders_path if user.shop&.agb
      return navigation.force! if navigation.force?
      return shopkeeper_settings_path
    end

    if user.admin?
      return navigation.force! if navigation.force?
      return admin_shops_path
    end
  end

  def kept_params
    {
      landing: request.params[:landing]
    }
  end

  private

  def without_code(url)
    uri = Addressable::URI.parse(url)
    params = uri.query_values
    uri.query_values = params.except('code') if params
    uri.to_s
  end

  def recover_last_order!
    if user.cart_orders.first
      cart_manager.store(user.cart_orders.first)
    end
  end

  # we must remove the empty orders in case they exist
  # NOTE : normally it shouldn't happen in the normal behaviour
  # but it appeared sometimes for some unknown reason
  # and made people blow up on sign-in
  def handle_past_orders!
    remove_all_empty_orders!

    user&.cart&.orders&.each do |order|
      if !order.bought? and order.timeout?
        order.cart_id = nil
        order.save
        order.reload
        OrderCanceller.new(order).all!
      end
    end
  end

  def remove_all_orders!
    user.orders.each do |order|
      order.order_items.delete_all
      order.delete
    end
  end

  def remove_all_empty_orders!
    user.orders.each do |order|
      # TODO : detection of paid orders should be way improved
      unless order.order_payments.first
        if order.order_items.count == 0
          order.delete
        end
      end
    end
  end

  def force_chinese!
    session[:locale] = :'zh-CN'
    I18n.locale = session[:locale]
  end

  def force_german!
    session[:locale] = :de
    I18n.locale = session[:locale]
  end

end
