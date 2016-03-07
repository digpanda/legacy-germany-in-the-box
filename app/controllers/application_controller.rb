require 'base64_to_upload'

class ApplicationController < ActionController::Base

  include FunctionCache
  include Mobvious::Rails::Controller

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  before_action :authenticate_user!, except: [:set_session_locale]

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action { params[:top_menu_active_part] = current_top_menu_active_part }

  after_action :reset_last_captcha_code!

  helper_method :current_order, :current_orders, :total_number_of_products

  def set_session_locale
    I18n.locale = params[:locale]
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
    list_popular_products_path
  end

  def current_top_menu_active_part
    :home
  end

end
