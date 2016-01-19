class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new]

  def new
    session[:login_advice_counter] = 1
    flash[:info] = 'Confirmation Successful and please login!'
    redirect_to home_path
  end

  def create
    if session[:login_advice_counter].present? and session[:login_advice_counter] >= Rails.configuration.login_failure_limit
      if valid_captcha?(params[:captcha])
        session.delete(:login_advice_counter)
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
    session.delete(:login_advice_counter)
    respond_to do |format|
      format.json {
        render json: { :status => :ok }
      }
    end
  end

end