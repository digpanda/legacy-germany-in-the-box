class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new]

  def create
    if session[:login_failure_counter].present? and session[:login_failure_counter] >= Rails.configuration.login_failure_limit
      if valid_captcha?(params[:captcha])
        session.delete(:login_failure_counter)
        super
      else
        flash[:error] = 'Captcha has wrong, try again.'
        redirect_to home_path
      end
    else
      super
    end
  end

  def cancel_login
    session.delete(:login_failure_counter)
    redirect_to request.referer
  end

end