class RegistrationsController < Devise::RegistrationsController

  def create
    if valid_captcha?(params[:captcha])
      super
    else
      flash[:error] = "Captcha has wrong, try a again."
      redirect_to home_path
    end
  end

  protected

  def after_sign_in_path_for(resource)
    popular_products_path
  end


  def after_inactive_sign_up_path_for(resource)
    '/user/openmailnoti'
  end
end