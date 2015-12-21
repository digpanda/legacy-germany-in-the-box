class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new]

  def create
    if valid_captcha?(params[:captcha])
      super
    else
      flash[:error] = "Captcha has wrong, try a again."
      redirect_to home_path
    end
  end
end