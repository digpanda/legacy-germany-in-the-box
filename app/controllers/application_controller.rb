require 'base64_to_upload'
require 'border_guru'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include UsersHelper
  include WickedPdfHelper
  include ErrorsHelper
  include LanguagesHelper

  include Mobvious::Rails::Controller

  # handle hard exception (which will throw a page error)
  # and soft ones even on dev / test (which will usually redirect the customer)
  unless Rails.env.development? || Rails.env.test?

    around_action :hard_exception_handler

    def hard_exception_handler
      yield
    rescue Mongoid::Errors::DocumentNotFound => exception
      throw_resource_not_found
    rescue Exception => exception
      throw_server_error_page
    ensure
      dispatch_error_email(exception)
    end

  end

  around_action :soft_exception_handler

  def soft_exception_handler
    yield
  rescue CanCan::AccessDenied
    throw_unauthorized_page
  end

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action :set_current_language

  helper_method :current_order, :current_orders, :total_number_of_products

  around_action :set_translation_locale, only: [:update], if: -> { current_user&.decorate&.admin? }

  before_action :set_categories

  after_filter :store_location

  def store_location
    # should be refactored to dynamic paths (obviously)
    #navigation.store :except => %w(/users/sign_in /users/sign_up /users/password/new /users/password/edit /users/confirmation /users/sign_out)
  end

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  protected

  def authenticate_user_with_force!
    NavigationHistory.new(request, session).store(:current, :force)
    authenticate_user!
  end

  def navigation
    @navigation ||= NavigationHistory.new(request, session)
  end

  def reach_todays_limit?(order, new_price_increase, new_quantity_increase)
    if current_user
      # if the user has logged in, we should check
      # whether the user has reached the limit today and the order itself has reached the the limit today
      current_user.decorate.reach_todays_limit?(order, new_price_increase) || order.decorate.reach_todays_limit?(new_price_increase, new_quantity_increase)
    else
      # if not, just check if the order has reached the limit today.
      # The further check will be done on the checkout step, after the user has logged in.
      order.decorate.reach_todays_limit?(new_price_increase, new_quantity_increase)
    end
  end

  def set_categories
    if potential_customer?
      @categories = Category.order(position: :asc).all
    end
  end

  def custom_sublayout
    "sublayout/_menu"
  end

  def current_order(shop_id)
    @current_order ||= begin

      shop = Shop.find(shop_id)
      order = CurrentOrderHandler.new(session, shop).retrieve

      if order
        # we don't forget to systematically get the quote api if the order has items
        refresh_order_quote!(order) if order.order_items.count > 0
      else
        order = Order.create
        set_order_id_in_session(shop.id, order.id.to_s)
      end

      if user_signed_in?
        unless current_user.decorate.customer?
          order.order_items.delete_all
          order.delete
        else
          order.user = current_user unless order.user
          order.save
        end
      end

      order

    end
  end

  def refresh_order_quote!(order)
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

  def current_orders
    session[:order_shop_ids] ||= {}
    @current_orders ||= session[:order_shop_ids].keys.compact.map { |shop_id| [shop_id, current_order(shop_id)] }.to_h
  end

  def total_number_of_products
    @total_number_of_products ||= current_orders.inject(0) { |sum, so| sum += so.compact[1].decorate.total_quantity }
  end

  def after_sign_in_path_for(resource)

    return navigation.force! if navigation.force?

    if current_user.decorate.customer?
      session[:locale] = :'zh-CN'
      navigation.back(1)
    elsif current_user.decorate.shopkeeper?
      session[:locale] = :'de'
      if current_user.shop && (not current_user.shop.agb)
        edit_producer_shop_path(current_user.shop.id)
      else
        shopkeeper_orders_path
      end
    elsif current_user.decorate.admin?
      admin_shops_path
    end
  end

  # we should put it into a library, there's an obvious possible abstraction here
  def breadcrumb_category
    add_breadcrumb @category.name, category_path(@category) unless @category.nil?
  end

  def breadcrumb_shop
    add_breadcrumb @shop.shopname, shop_path(@shop) unless @shop.nil?
  end

  def breadcrumb_product
    add_breadcrumb @product.name, product_path(@product) unless @product.name.nil?
  end

  def breadcrumb_home
    add_breadcrumb I18n.t(:home, scope: :breadcrumb), :root_path
  end

  private

  # cancancan hook
  def current_ability
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join('/').camelize
    Ability.new(current_user, controller_namespace)
  end

  def reset_shop_id_from_session(shop_id)
    session[:order_shop_ids]&.delete(shop_id)
  end

  def set_order_id_in_session(shop_id, order_id)
    session[:order_shop_ids] ||= {}
    session[:order_shop_ids]["#{shop_id}"] = order_id
  end

end
