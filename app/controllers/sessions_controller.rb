class SessionsController < Devise::SessionsController

  skip_before_filter :verify_signed_out_user

  respond_to :html, :json

  def new
    session[:login_advice_counter] = 1
    redirect_to root_path
  end

  def create
    respond_to do |format|
      format.html {
        if session[:login_advice_counter].present? and session[:login_advice_counter] >= Rails.configuration.login_failure_limit
          if valid_captcha?(params[:captcha])
            session.delete(:login_advice_counter)
            super
          else
            flash[:error] = flash[:error] = I18n.t(:wrong_captcha, scope: :top_menu)
            redirect_to root_path
          end
        else
          super
        end
      }

      format.json {
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        current_user.update authentication_token: nil
        render :json => { :authentication_token => current_user.authentication_token }, :status => :ok
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
          render :json => {}, :status => :ok
        else
          render :json => {}, :status => :unprocessable_entity
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