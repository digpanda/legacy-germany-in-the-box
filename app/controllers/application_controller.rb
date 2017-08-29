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

  before_action :solve_wechat_user, :solve_silent_login, :solve_origin, :solve_landing

  # if a user comes from wechat browser and is not logged-in yet
  # we force-login him to the correct domain
  def solve_wechat_user
    return if params[:code]
    return if current_user
    return unless identity_solver.wechat_browser?
    redirect_to WechatUrlAdjuster.new(identity_solver.wechat_url).adjusted_url
  end

  # we try to silent login the users
  # with the code in parameters (typically wechat related)
  def solve_silent_login
    return unless params[:code]
    return unless wechat_silent_login.connect!(params[:code])
    redirect_to wechat_silent_login.redirect_url
  end

  def wechat_silent_login
    @wechat_silent_login ||= WechatSilentLogin.new(request, navigation, current_user, cart_manager)
  end

  def activate_weixin_js_config
    @weixin_js_config ||= begin
      ticket = WeixinTicket.new(cache_scope: request.host).resolve!
      return false unless ticket.success?
      js_config = WeixinApiJsConfig.new(request: request, ticket: ticket.data[:ticket]).resolve!
      return false unless js_config.success?
      SlackDispatcher.new.message("CURRENT JS CONFIG : #{js_config}")
      js_config.data
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
    @cart_manager ||= CartManager.new(request, current_user)
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
    'application'
  end

  def freeze_header
    @freeze_header = true
  end

  def minimal_layout
    @minimal_layout = true
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
