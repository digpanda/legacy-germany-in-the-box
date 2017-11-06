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

      flash[:success] = I18n.t('notice.success_subscription')

      # some stuff will be going on
      sign_up(resource_name, resource)

      if resource.freshly_created?
        AfterSignupHandler.new(request, resource).solve
      end

      # we auto sign-in the user
      sign_in(:user, resource)

      if resource.customer?
        Notifier::Customer.new(resource).welcome
      elsif resource.shopkeeper?
        Notifier::Shopkeeper.new(resource).welcome
      end

      respond_with resource, location: after_sign_up_path_for(resource)
      return

    else
      clean_up_passwords resource
      set_minimum_password_length

      session[:signup_advice_counter] = 1
      flash[:error] = resource.errors.full_messages.join(', ')
      render :new
    end
  end

  protected

    # NOTE : it should not be triggered, but in case
    # it is we just redirect to normal after sign up method
    def after_inactive_sign_up_path_for(resource)
      after_sign_up_path_for(resource)
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
