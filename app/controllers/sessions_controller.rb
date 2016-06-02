class SessionsController < Devise::SessionsController

  skip_before_filter :verify_signed_out_user

  before_action :authenticate_user!, except: [:new, :create, :set_redirect_location]

  respond_to :html, :json

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def new
    session[:login_advice_counter] = 1
    redirect_to root_path
  end

  def create

    if session[:login_advice_counter].present? and session[:login_advice_counter] >= Rails.configuration.login_failure_limit
      if valid_captcha?(params[:captcha])
        session.delete(:login_advice_counter)
        super
      else
        flash[:error] = I18n.t(:wrong_captcha, scope: :top_menu)
        redirect_to root_path
      end
    else

      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)

    end

  end

  def destroy
    super
  end

  def cancel_login
    session.delete(:login_advice_counter)
  end

end