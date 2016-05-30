require 'base64_to_upload'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include UsersHelper
  
  include AppCache

  include Mobvious::Rails::Controller

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  before_action :authenticate_user!, except: [:set_session_locale]

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action { params[:top_menu_active_part] = current_top_menu_active_part }

  before_action :set_locale, except: :set_session_locale

  after_action :reset_last_captcha_code!

  helper_method :current_order, :current_orders, :total_number_of_products, :extract_locale

  around_action :set_translation_locale, only: [:update], if: -> { current_user&.is_admin? }

  before_action :set_all_categories

  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def set_session_locale
    session[:locale] = params[:locale]

    if request.referer.nil?
      redirect_to root_url and return
    else
      redirect_to request.referer and return
    end

  end

  protected

  def set_all_categories
    if seems_like_a_customer?
      @category_navigation_store ||= CategoryNavigationStore.new
    end
  end
  
  def custom_sublayout
    "sublayout/_#{current_user.role}"
  end
  
  def current_order(shop_id)
    @current_order ||= begin
      if has_order?(shop_id)
        order = Order.find(session[:order_ids][shop_id])
      end

      unless order
        order = Order.create
        session[:order_ids][shop_id] = order.id.to_s
      end

      if user_signed_in?
        unless current_user.is_customer?
          current_orders.values.each do |o|
            o.order_items.delete_all
            o.delete
          end
        else
         order.user = current_user unless order.user
         order.save
        end
      end

      order
    end
  end

  def current_cart(shop_id)
    cart = Cart.new

    current_order(shop_id).order_items.each do |i|
        cart.add(i.sku, i.quantity)
    end

    BorderGuru.calculate_quote(
        cart: cart,
        shop: Shop.find(shop_id),
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )

    cart
  end

  def has_order?(shop_id)
    session[:order_ids][shop_id].present? if (session[:order_ids] ||= {})
  end

  def current_orders
    @current_orders ||= session[:order_ids].compact.delete_if { |_, oid| oid.blank? } .map { |sid, oid| [sid, Order.find(oid)] }.to_h
  end

  def current_carts
    carts = {}

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

    carts
  end

  def total_number_of_products
    @total_number ||= (session[:order_ids] == nil || session[:order_ids].empty?) ?  0 : current_orders.inject(0) { |sum, so| sum += so.compact[1].total_amount }
  end

  def after_sign_in_path_for(resource)
    if current_user.is_customer?
      root_path
    elsif current_user.is_shopkeeper?
      if current_user.shop && (not current_user.shop.agb)
        edit_producer_shop_path(current_user.shop.id, :user_info_edit_part => :edit_producer)
      else
        edit_setting_shop_path(current_user.shop.id, :user_info_edit_part => :edit_shop)
      end
    elsif current_user.is_admin?
      shops_path(:user_info_edit_part => :edit_shops)
    end
  end

  def current_top_menu_active_part
    :home
  end

  def set_locale
    params[:locale]= session[:locale]

    if params[:locale]
      I18n.locale = params[:locale]
    else
      if current_user&.is_customer?
        if 'zh' == extract_locale
          I18n.locale = :'zh-CN'
        else
          I18n.locale = :de
        end
      elsif current_user&.is_shopkeeper?
        I18n.locale = :de
      elsif current_user&.is_admin?
        I18n.locale = :'zh-CN'
      else
        if 'zh' == extract_locale
          I18n.locale = :'zh-CN'
        else
          I18n.locale = :de
        end
      end
    end
  end

  def set_translation_locale
    cl = I18n.locale
    I18n.locale = params[:translation].to_sym if params[:translation]
    yield
    I18n.locale = cl
  rescue
    I18n.locale = cl
  end

  def extract_locale
    request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : 'de'
  end
end
