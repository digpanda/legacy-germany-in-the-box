class UserFailure < Devise::FailureApp
  def redirect_url
    home_path
  end

  def respond
    if http_auth?
      session.delete[:login_advice_counter]
      http_auth
    else
      if session[:login_advice_counter].present?
        session[:login_advice_counter] += 1
      else
        session[:login_advice_counter] = 1
      end

      flash[:error] = I18n.t(:unauthenticated, :scope => [:devise, :failure])
      redirect
    end
  end
end