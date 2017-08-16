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

  before_action :solve_silent_login, :solve_origin, :solve_landing, :weixin_config

  def solve_silent_login
    if params[:code]
      if wechat_api_connect_solver.success?
        user = wechat_api_connect_solver.data[:customer]
        sign_out
        sign_in(:user, user)
        slack.message "[Wechat] Customer automatically logged-in (`#{current_user&.id}`)", url: admin_user_path(current_user)
        redirect_to AfterSigninHandler.new(request, navigation, current_user, cart_manager).solve!(refresh: true)
      else
        slack.message "[Wechat] Auth failed (`#{wechat_api_connect_solver.error}`)"
      end
    end
  end

  def wechat_api_connect_solver
    @wechat_api_connect_solver ||= WechatApiConnectSolver.new(params[:code]).resolve!
  end

  # TODO : this has to be moved elsewhere and not called each time
  def weixin_config
    @weixin_config ||= begin
      if current_user&.tester?
        ticket = WeixinApiTicket.new.resolve!
        return unless ticket.success?
        SlackDispatcher.new.message("TICKET : #{ticket.data}")
        WeixinApiJsConfig.new(request: request, ticket: ticket.data[:ticket]).resolve!
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
