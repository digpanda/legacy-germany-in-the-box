class Connect::RegistrationsController < Devise::RegistrationsController
  include Base64ToUpload

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  before_action(only:  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  respond_to :html, :json

  def new
    session[:signup_advice_counter] = 1
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def create
    build_resource(sign_up_params)

    yield resource if block_given?
    resource.save

    if resource.persisted?

      if resource.active_for_authentication?

        flash[:success] = I18n.t('notice.success_subscription')

        sign_up(resource_name, resource)

        if resource.freshly_created?
          AfterSignupHandler.new(request, resource).solve
        end

        sign_in(:user, User.find(resource.id)) # auto sign in

        if resource.customer?
          Notifier::Customer.new(resource).welcome
        elsif resource.shopkeeper?
          Notifier::Shopkeeper.new(resource).welcome
        end

        respond_with resource, location: after_sign_up_path_for(resource)
        return

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
      flash[:error] = resource.errors.full_messages.join(', ')
      render :new

    end
  end

  protected

    def after_inactive_sign_up_path_for(resource)
      flash[:info] = I18n.t('top_menu.email_confirmation_msg')
      popular_products_path
    end

    def configure_devise_permitted_parameters
      registration_params = [:fname, :lname, :email, :password, :password_confirmation, :birth, :gender, :pic]

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
