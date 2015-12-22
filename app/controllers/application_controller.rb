require 'base64_to_upload'

class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_order

  protected

  def current_order
    @current_order ||= begin
      if has_order?
        order = Order.find(session[:order_id])
      end

      unless order
        order = Order.create!
        session[:order_id] = order.id
        order
      end

      order
    end
  end

  def has_order?
    not session[:order_id].nil?
  end

  def require_signin!
    if session[:customer_id].nil?
      flash[:warning] = 'You haven\'t logged in.'
      session[:url_before_login] = request.original_url
      redirect_to home_path
    else
      session.delete(:url_before_login)
    end
  end

  def current_customer
    begin
      @current_customer ||= Customer.eager_load(:orders).find(session[:customer_id]) if session[:customer_id]
    rescue
      session[:customer_id] = nil
    end
  end

  def after_sign_in_path_for(resource)
    '/productsi/50'
  end

  def configure_devise_permitted_parameters
    registration_params = [:username, :email, :password, :password_confirmation,:birth,:lang,:gender]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(registration_params)
      }
    end
  end

end
