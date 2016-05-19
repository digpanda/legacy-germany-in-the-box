class SessionsController < Devise::SessionsController

  skip_before_filter :verify_signed_out_user

  before_action :authenticate_user!, except: [:new, :create, :set_redirect_location]

  respond_to :html, :json

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def new
    session[:login_advice_counter] = 1
    redirect_to root_path
  end

  # set a new location after log-in (called via AJAX from the front-end only) ; should be in API part
  def set_redirect_location
    session[:previous_url] = params["location"] unless params["location"].nil?
    render json: {success: true} and return # should be improved
  end

  # should be in an API part (called via AJAX from the front-end only)
  def is_auth
    render json: {success: true, is_auth: !current_user.nil?}
  end

  def create

    respond_to do |format|

      format.html {
        if session[:login_advice_counter].present? and session[:login_advice_counter] >= Rails.configuration.login_failure_limit
          if valid_captcha?(params[:captcha])
            session.delete(:login_advice_counter)
            super
          else
            flash[:error] = I18n.t(:wrong_captcha, scope: :top_menu)
            redirect_to root_path
          end
        else

            self.resource = warden.authenticate!(auth_options)
            sign_in(resource_name, resource)
            yield resource if block_given?
            respond_with resource, location: after_sign_in_path_for(resource)

        end
      }

      format.json {
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        current_user.update authentication_token: nil
        render :login, :status => :ok
      }

    end
  end

  def destroy

    respond_to do |format|
      format.html {
        super
      }

      format.json {
        if current_user
          current_user.update authentication_token: nil
          Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
          render :json => ApiFormat.success(:user, current_user), :status => :ok
        else
          render :json => ApiFormat.fail("You are not logged-in"), :status => :unprocessable_entity
        end
      }
    end
    
  end

  def cancel_login
    session.delete(:login_advice_counter)
    respond_to do |format|
      format.json {
        render :json => {}, :status => :ok
      }
    end
  end

end