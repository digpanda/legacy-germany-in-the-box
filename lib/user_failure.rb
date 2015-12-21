class UserFailure < Devise::FailureApp
  def redirect_url
    home_path
  end

  def respond
    if http_auth?
      http_auth
    else
      flash[:error] = I18n.t(:unauthenticated, :scope => [:devise, :failure])
      redirect
    end
  end
end