require 'addressable/uri'

class AfterSigninHandler

  include Rails.application.routes.url_helpers

  attr_reader :request, :navigation, :session, :user, :cart_manager

  def initialize(request, navigation, user, cart_manager)
    @request = request
    @navigation = navigation
    @session = request.session
    @user = user
    @cart_manager = cart_manager
  end

  # this method is called from different points on the site
  # one of the point is WeChat silent login which should keep
  # all param on redirection but the `code` one, it's the only case using `refresh: true`
  # we basically refresh the page or redirect to missing info page while keeping all the rest
  def solve!(refresh:false)
    if user.customer?
      force_chinese!
      handle_past_orders!
      recover_last_orders!
      return without_code missing_info_customer_account_path(kept_params) if user.missing_info?
      return navigation.force! if navigation.force?

      # NOTE : we remove the code param from the redirect URL
      # because if the user comes from WeChat that would make an infinite loop
      # we can either refresh the current page or go back
      if refresh
        return without_code request.url
      else
        return without_code navigation.back(1, identity_solver.landing_solver.recover)
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

  # NOTE : don't forget to use `without_code`
  # to avoid infinite loop linked to the `code` param
  # STILL being present here
  def kept_params
    request.query_parameters
  end

  private

  # NOTE : mayber we should just integrate it via params at initialization ?
  # - Laurent, 13/07/2017
  def identity_solver
    @identity_solver ||= IdentitySolver.new(request, user)
  end

  def without_code(url)
    uri = Addressable::URI.parse(url)
    params = uri.query_values
    uri.query_values = params.except('code') if params
    uri.to_s
  end

  # TODO : improve the cart handling so a use always
  # has a cart.
  def recover_last_orders!
    user.cart&.orders&.each do |order|
      cart_manager.store(order)
    end
  end

  # we must remove the empty orders in case they exist
  # NOTE : normally it shouldn't happen in the normal behaviour
  # but it appeared sometimes for some unknown reason
  # and made people blow up on sign-in
  def handle_past_orders!
    remove_all_empty_orders!
    remove_timeout_orders!
  end

  def remove_timeout_orders!
    user.cart&.orders&.each do |order|
      if !order.bought? && order.timeout?
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
