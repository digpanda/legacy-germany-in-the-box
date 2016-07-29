require 'base64_to_upload'
require 'border_guru'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include UsersHelper
  include NavigationHistoryHelper
  include WickedPdfHelper
  include ErrorsHelper
  include LanguagesHelper

  include AppCache

  include Mobvious::Rails::Controller

  unless Rails.env.development? # only on staging / production / test otherwise we show the full error
    rescue_from Exception, :with => :throw_server_error_page
    rescue_from CanCan::AccessDenied, :with => :throw_unauthorized_page
    rescue_from Mongoid::Errors::DocumentNotFound, :with => :throw_resource_not_found
  end
  
  #around_action :exception_handler
# WE SHOULD CHANGE THE ERROR HANDLING TO THIS AT SOME POINT
=begin
  def exception_handler
    yield
  rescue Mongoid::Errors::DocumentNotFound => exception
    dispatch_error_email(exception)
    throw_resource_not_found
  rescue CanCan::AccessDenied => exception
    dispatch_error_email(exception)
    throw_unauthorized_page
  rescue Exception => exception
    dispatch_error_email(exception)
    throw_server_error_page
  end
=end

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action { params[:top_menu_active_part] = current_top_menu_active_part }

  before_action :set_current_language

  after_action :reset_last_captcha_code!

  helper_method :current_order, :current_orders, :total_number_of_products

  around_action :set_translation_locale, only: [:update], if: -> { current_user&.is_admin? }

  before_action :set_categories

  after_filter :store_location

  def store_location
    # should be refactored to dynamic paths (obviously)
    store_navigation_history :except => ["/users/sign_in","/users/sign_up", "/users/sign_up", "/users/password/new", "/users/password/edit", "/users/confirmation", "/users/sign_out"]
  end

  protected

  def reach_todays_limit?(order, new_price_increase, new_quantity_increase)
    # if the user has logged in, we should check, whether the user has reached the limit today and the order itself has reached the the limit today
    if current_user.present?
      return current_user.decorate.reach_todays_limit?(order, new_price_increase) || order.decorate.reach_todays_limit?(new_price_increase, new_quantity_increase)
    end

    # if not, just check if the order has reached the limit today. The further check will be done on the checkout step, after the user has logged in.
    return order.decorate.reach_todays_limit?(new_price_increase, new_quantity_increase)
  end

  def set_categories
    if seems_like_a_customer?
      @categories = Category.all
    end
  end
  
  def custom_sublayout
    "sublayout/_#{current_user.role}"
  end
  
  def current_order(shop_id)
    @current_order ||= _current_order(shop_id)
  end

  def current_cart(shop_id)

    cart = Cart.new
    
    current_order(shop_id).order_items.each do |i|
      cart.add(i.sku, i.quantity)
    end


    begin
      BorderGuru.calculate_quote(
          cart: cart,
          shop: Shop.find(shop_id),
          country_of_destination: ISO3166::Country.new('CN'),
          currency: 'EUR'
      )
    rescue Net::ReadTimeout => e
      logger.fatal "Failed to connect to Borderguru: #{e}"
      return nil
    else
      return cart
    end
  end

  def has_order?(shop_id)
    session[:order_ids] ||= {}
    session[:order_ids].delete_if{ |k,v| k.nil? || v.nil?}[shop_id].present?
  end

  def current_orders
    session[:order_ids] ||= {}
    @current_orders ||= session[:order_ids].keys.compact.map { |sid| [sid, _current_order(sid)] }.to_h
  end

  def current_carts
    carts = {}

    begin
      current_orders.map do |s, o|
        carts[s] = Cart.new

        o.order_items.each do |i|
          carts[s].add(i.sku, i.quantity)

          BorderGuru.calculate_quote(
              cart: carts[s],
              shop: Shop.find(s),
              country_of_destination: ISO3166::Country.new('CN'),
              currency: 'EUR'
          )

        end
      end

    rescue BorderGuru::Error => e
      flash[:error] = I18n.t(:shipping_partner_problem, :notice, :e => e)
      redirect_to root_path and return
    end
    carts
  end

  def total_number_of_products
    @total_number ||= (session[:order_ids] == nil || session[:order_ids].empty?) ?  0 : current_orders.inject(0) { |sum, so| sum += so.compact[1].decorate.total_quantity }
  end

  def after_sign_in_path_for(resource)
    if current_user.is_customer?
      session[:locale] = :'zh-CN'
      navigation_history(1)
    elsif current_user.is_shopkeeper?
      session[:locale] = :'de'
      if current_user.shop && (not current_user.shop.agb)
        edit_producer_shop_path(current_user.shop.id, :user_info_edit_part => :edit_producer)
      else
        show_orders_users_path(:user_info_edit_part => :edit_order)
      end
    elsif current_user.is_admin?
      shops_path(:user_info_edit_part => :edit_shops)
    end
  end

  def current_top_menu_active_part
    :home
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
    session[:order_ids]&.delete(shop_id)
  end

  def set_order_id_in_session(shop_id, order_id)
    session[:order_ids] ||= {}
    session[:order_ids][shop_id] = order_id
  end

  def _current_order(shop_id)
    if has_order?(shop_id)
      order = Order.find(session[:order_ids][shop_id])

      if order.status == :success
        reset_shop_id_from_session(shop_id)
        order = nil
      end
    end

    unless order
      order = Order.create
      set_order_id_in_session(shop_id, order.id.to_s)
    end

    if user_signed_in?
      unless current_user.is_customer?
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
