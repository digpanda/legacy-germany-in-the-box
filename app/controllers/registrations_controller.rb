class RegistrationsController < Devise::RegistrationsController

  def create
    if valid_captcha?(params[:captcha])
      build_resource
      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_up(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        flash[:error] ||= resource.errors.full_messages.join(', ')
        redirect_to home_path
      end
    else
      flash[:error] = "Captcha has wrong, try a again."
      redirect_to home_path
    end
  end

  protected

  def after_sign_in_path_for(resource)
    '/productsi/50'
  end


  def after_inactive_sign_up_path_for(resource)
    '/user/openmailnoti'
  end
end