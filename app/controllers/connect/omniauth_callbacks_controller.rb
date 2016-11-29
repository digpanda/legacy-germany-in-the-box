class Connect::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # skip CSRF on create.
  skip_before_filter :verify_authenticity_token

  def wechat
    if wechat_solver.success?
      flash[:success] = I18n.t(:wechat_login, scope: :notice)
      sign_in(:user, wechat_solver.data[:customer])
      redirect_to after_sign_in_path_for(wechat_solver.data[:customer])
    else
      failure
    end
  end

  def failure
    flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
    redirect_to(:back)
  end

  private

  def wechat_solver
    @wechat_solver ||= WechatConnectSolver.new(request.env["omniauth.auth"]).resolve!
  end

end
