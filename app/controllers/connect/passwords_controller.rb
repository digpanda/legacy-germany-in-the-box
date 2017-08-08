class Connect::PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    user = User.where(email: params[:email]).first
    unless user
      flash[:error] = I18n.t(:email_not_found, scope: :password_recovery)
      redirect_to new_user_password_path
      return
    end

    user.send_reset_password_instructions
    yield user if block_given?

    if successfully_sent?(user)
      flash[:success] = I18n.t(:instruction_sent, scope: :password_recovery)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(:user))
    else
      respond_with(user)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash[:success] = I18n.t(:password_updated, scope: :password_recovery)
        sign_in(resource_name, resource)
        redirect_to root_url
        return
      end

    end

    flash[:error] = resource.errors.full_messages.join(', ')
    redirect_to request.referer
    return
  end

  protected

    def after_resetting_password_path_for(resource)
      Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_user_session_path(resource_name)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_user_session_path(resource_name) if is_navigational_format?
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_user_session_path(resource_name)
      end
    end

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
      resource.respond_to?(:unlock_strategy_enabled?) &&
      resource.unlock_strategy_enabled?(:email)
    end

    def translation_scope
      'devise.passwords'
    end
end
