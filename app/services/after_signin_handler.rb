require 'addressable/uri'

# after someone successfully sign-in a set of process will be initialized
# this class handles all of them.
class AfterSigninHandler
  include Rails.application.routes.url_helpers

  attr_reader :request, :navigation, :user, :cart_manager

  def initialize(request, navigation, user, cart_manager)
    @request = request
    @navigation = navigation
    @user = user
    @cart_manager = cart_manager
  end

  # this method is called from different points on the site
  # one of the point is WeChat silent login which should keep
  # all param on redirection but the `code` one, it's the only case using `refresh: true`
  # we basically refresh the page or redirect to missing info page while keeping all the rest
  def solve(refresh: false)
    return root_url if banished?

    # simple dispatch to notify any log-in
    handle_slack

    if user.customer?
      return as_customer(refresh)
    end

    # if the person is not a customer
    # he doesn't need any order.
    remove_all_orders

    if user.shopkeeper?
      return as_shopkeeper
    end

    if user.admin?
      return as_admin
    end
  end

  # NOTE : don't forget to use `without_code`
  # to avoid infinite loop linked to the `code` param
  # STILL being present here
  def kept_params
    request.query_parameters
  end

  private

    def as_admin
      return navigation.force! if navigation.force?
      admin_home_path
    end

    def as_shopkeeper
      force_german
      return shopkeeper_orders_path if user.shop&.agb
      return navigation.force! if navigation.force?
      shopkeeper_settings_path
    end

    def as_customer(refresh)
      force_chinese
      handle_referrer_binding
      handle_precreated
      handle_past_orders
      handle_event

      # we assign what was in session
      # if it exists
      handle_introducer
      handle_label
      handle_group

      return without_code missing_info_customer_account_path(kept_params) if user.missing_info?
      return navigation.force! if navigation.force?

      # NOTE : we remove the code param from the redirect URL
      # because if the user comes from WeChat that would make an infinite loop
      # we can either refresh the current page or go back
      if refresh
        # if the user is a referrer which just logged-in and tries to go to the user menu
        # we directly redirect him to the referrer area
        if user.referrer? && user_goes_to_menu?
          return without_code customer_referrer_path
        else
          return without_code request.url
        end
      else
        # if the user is a referrer and connected via QRCode given to him
        # we will force him into his QRCode area
        if user.referrer?
          return without_code customer_referrer_path
        else
          return without_code navigation.back(1, identity_solver.landing_solver.recover)
        end
      end
    end

    def user_goes_to_menu?
      PathMatcher.new(request).match_location? menu_customer_account_path
    end

    # NOTE : mayber we should just integrate it via params at initialization ?
    # - Laurent, 13/07/2017
    def identity_solver
      @identity_solver ||= IdentitySolver.new(request, user)
    end

    def handle_slack
      SlackDispatcher.new.login(user)
    end

    def handle_event
      EventDispatcher.new.customer_signed_in(user).dispatch!
    end

    def banished?
      if user.banished
        session.clear
        return true
      end
      false
    end

    def handle_referrer_binding
      if session[:reference_id]
        referrer = Referrer.where(reference_id: session[:reference_id]).first
        ReferrerBinding.new(referrer).bind(user) if referrer
        session[:reference_id] = nil
      end
    end

    def without_code(url)
      uri = Addressable::URI.parse(url)
      params = uri.query_values
      uri.query_values = params.except('code') if params
      uri.to_s
    end

    def handle_precreated
      if user.precreated
        user.precreated = false
        user.save
      end
    end

    # we must remove the empty orders in case they exist
    # NOTE : normally it shouldn't happen in the normal behaviour
    # but it appeared sometimes for some unknown reason
    # and made people blow up on sign-in
    def handle_past_orders
      remove_all_empty_orders
      remove_timeout_orders
    end

    # if a param[:friend] was previously stored
    # we try to run the mechanism to assign it to this account
    def handle_introducer
      if session[:introducer]
        introducer = User.where(id: session[:introducer]).first
        if introducer && user.introducer.nil?
          user.introducer = introducer
          user.save
        end
        session[:introducer] = nil
      end
    end

    # if a param[:label] was previously stored
    # we try to run the mechanism to assign it to this account
    def handle_label
      if session[:label]
        unless user.label
          user.update(label: session[:label])
        end
        session[:label] = nil
      end
    end

    # if a param[:group] was previously stored
    # we try to run the mechanism to assign it to this account
    def handle_group
      if session[:group]
        unless user.group != :default || user.referrer
          user.update(group: decrypt_group(session[:group]))
        end
        session[:group] = nil
      end
    end

    def remove_timeout_orders
      user.cart&.orders&.each do |order|
        if !order.bought? && order.timeout?
          order.cart_id = nil
          order.save
          order.reload
          OrderCanceller.new(order).all!
        end
      end
    end

    def remove_all_orders
      user.orders.each do |order|
        order.order_items.delete_all
        order.delete
      end
    end

    def remove_all_empty_orders
      user.orders.each do |order|
        # TODO : detection of paid orders should be way improved
        unless order.order_payments.first
          if order.order_items.count == 0
            order.delete
          end
        end
      end
    end

    def force_chinese
      session[:locale] = :'zh-CN'
      I18n.locale = session[:locale]
    end

    def force_german
      session[:locale] = :de
      I18n.locale = session[:locale]
    end

    def session
      request.session
    end

    def decrypt_group(group)
      case group.to_i
      when 0
        :default
      when 1
        :student
      when 2
        :junior
      when 3
        :senior
      else
        group
      end
    end
end
