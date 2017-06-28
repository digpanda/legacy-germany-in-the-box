require 'base64_to_upload'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include Application::Exceptions
  include Application::Ability
  include Application::Language
  include Application::Devise
  include Application::Breadcrumb
  include Application::Categories

  include Mobvious::Rails::Controller

  helper_method :navigation, :cart_manager, :identity_solver

  before_action :silent_login, :solve_origin, :solve_landing

  def silent_login
    if params[:code]
      if wechat_auth.success?
        sign_out
        user = wechat_auth.data[:customer]
        sign_in(:user, user)
        SlackDispatcher.new.silent_login_attempt("[Wechat] Customer automatically logged-in (`#{current_user&.id}`)")
        SlackDispatcher.new.message("REQUEST FOR WECHAT #{request.url}")
        redirect_to SigninHandler.new(request, navigation, current_user, cart_manager).solve!(refresh: true)
      end
    end
  end

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  def slack
    @slack ||= SlackDispatcher.new
  end

  def navigation
    @navigation ||= NavigationHistory.new(request, session)
  end

  def cart_manager
    @cart_manager ||= CartManager.new(session, current_user)
  end

  def identity_solver
    @identity_solver ||= IdentitySolver.new(request, current_user)
  end

  def setting
    @setting ||= Setting.instance
  end

  def custom_sublayout
    "layouts/#{identity_solver.section}/submenu"
  end

  def default_layout
    "application"
  end

  def wechat_auth
    @wechat_auth ||= WechatAuth.new(params[:code], params[:token], params[:force_referrer]).resolve!
  end

  def freeze_header
    @freeze_header = true
  end

  def solve_origin
    identity_solver.origin_setup!
  end

  def solve_landing
    identity_solver.landing_solver.setup!
  end

  def restrict_to(section)
    unless identity_solver.section == section # :customer, :shopkeeper, :admin
      navigation.reset! # we reset to avoid infinite loop
      throw_unauthorized_page
    end
  end

end
