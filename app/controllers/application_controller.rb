require 'base64_to_upload'

class ApplicationController < ActionController::Base

  include FunctionCache
  include Mobvious::Rails::Controller

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  before_action :authenticate_user!, except: [:set_session_locale]

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action { params[:top_menu_active_part] = current_top_menu_active_part }

  after_action :reset_last_captcha_code!

  helper_method :current_order

  def set_session_locale
    I18n.locale = params[:locale]
    redirect_to request.referer
  end

  protected

  def current_order
    @current_order ||= begin
      if has_order?
        begin
          order = Order.find(session[:order_id])
        rescue
          order = nil
        end
      end

      unless order
        order = Order.create!
        session[:order_id] = order.id
        order
      end

      if user_signed_in?
        order.user = current_user
      end

      order
    end
  end

  def has_order?
    session[:order_id].present?
  end

  def after_sign_in_path_for(resource)
    list_popular_products_path
  end

  def current_top_menu_active_part
    :home
  end

end
