class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new]

  def create
    if session[:login_failure_counter].present? and session[:login_failure_counter] > 2
      if valid_captcha?(params[:captcha])
        super
      else
        flash[:error] = "Captcha has wrong, try again."
        redirect_to home_path
      end
    else
      super
    end

  end

end