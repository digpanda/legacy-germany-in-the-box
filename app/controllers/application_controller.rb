require 'base64_to_upload'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include FunctionCache

  include Mobvious::Rails::Controller

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  before_action :authenticate_user!, except: [:set_session_locale]

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action { params[:top_menu_active_part] = current_top_menu_active_part }

  before_action :set_locale, except: :set_session_locale

  after_action :reset_last_captcha_code!

  helper_method :current_order, :current_orders, :total_number_of_products, :extract_locale

  def set_session_locale
    session[:locale] = params[:locale]
    redirect_to request.referer
  end

  protected

  def current_order(shop_id)
    @current_orders ||= {}
    session[:order_ids] ||= {}

    @current_orders[shop_id] ||= begin
      if has_order?(shop_id)
        order = Order.find(session[:order_ids][shop_id])
      end

      unless order
        order = Order.create
        session[:order_ids][shop_id] = order.id
      end

      if user_signed_in?
        if [:shopkeeper, :admin].include?(current_user.role)
          @current_orders.values.each do |o|
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

  def has_order?(shop_id)
     session[:order_ids] ? session[:order_ids][shop_id].present? : false
  end

  def current_orders
    @current_orders ||= session[:order_ids].map { |sid, oid| [Shop.find(sid), Order.find(oid)] unless sid.empty? }.compact.uniq
  end

  def total_number_of_products
    @total_number ||= session[:order_ids] ? current_orders.inject(0) { |sum, so| sum += so[1].total_amount } : 0
  end

  def after_sign_in_path_for(resource)
    if current_user.role == :customer
      list_popular_products_path
    elsif current_user.role == :shopkeeper
      if current_user.shop && (not current_user.shop.agb)
        edit_user_path(current_user, :user_info_edit_part => :edit_shopkeeper_agb)
      else
        edit_user_path(current_user, :user_info_edit_part => :edit_shop)
      end
    else
      root_path
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
      if current_user and current_user.role == :customer
        if 'zh' == extract_locale
          I18n.locale = :'zh-CN'
        else
          I18n.locale = :de
        end
      elsif current_user and current_user.role == :shopkeeper
        I18n.locale = :de
      elsif current_user and current_user.role == :admin
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

  def extract_locale
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
