class RegistrationsController < Devise::RegistrationsController

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  include Base64ToUpload

  before_action(:only =>  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  respond_to :html, :json

  def new
    session[:signup_advice_counter] = 1
  end

  def cancel_signup
    session.delete(:signup_advice_counter)
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
        redirect_to root_path
      end
    else
      session[:signup_advice_counter] = 1
      flash[:error] = I18n.t(:wrong_captcha, scope: :top_menu)
      redirect_to root_path
    end

  end

  protected

  def after_inactive_sign_up_path_for(resource)
    flash[:info] = I18n.t(:email_confirmation_msg, scope: :top_menu)
    popular_products_path
  end

  def configure_devise_permitted_parameters
    registration_params = [:username, :email, :password, :password_confirmation, :birth, :gender, :pic]

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