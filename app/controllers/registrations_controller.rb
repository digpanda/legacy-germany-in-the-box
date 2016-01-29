class RegistrationsController < Devise::RegistrationsController

  respond_to :html, :json

  def new
    session[:signup_advice_counter] = 1
    redirect_to home_path
  end


  def cancel_signup
    session.delete(:signup_advice_counter)
    respond_to do |format|
      format.json {
        render json: {}
      }
    end
  end

  def create
    if valid_captcha?(params[:captcha])
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end

        session.delete(:signup_advice_counter)
      else
        clean_up_passwords resource
        set_minimum_password_length

        session[:signup_advice_counter] = 1
        flash[:error] = resource.errors.full_messages.first
        redirect_to home_path
      end
    else
      session[:signup_advice_counter] = 1
      flash[:error] = "Captcha has wrong, try a again."
      redirect_to home_path
    end
  end

  protected

  def after_sign_in_path_for(resource)
    popular_products_path
  end


  def after_inactive_sign_up_path_for(resource)
    flash[:info] = 'We have sent an email to you. Please confirm it, before you login!'
    popular_products_path
  end
end