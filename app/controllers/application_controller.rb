require 'base64_to_upload'
require 'border_guru'

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

  before_action :silent_login

  def silent_login
    if params[:code]
      code = params[:code]
      SlackDispatcher.new.silent_login_attempt('We got a `code` in the parameters')
      # get access token
      parsed_response = get_access_token(code)
      openid = parsed_response['openid']
      unionid = parsed_response['unionid']
      SlackDispatcher.new.silent_login_attempt("errcode: #{parsed_response['errcode']}")

      return if parsed_response['errcode']

      user = User.where(provider: 'wechat', uid: openid, wechat_unionid: unionid).first

      if user
        SlackDispatcher.new.silent_login_attempt('User exists, auto login incomming')
        sign_in_user(user)
      else
        SlackDispatcher.new.silent_login_attempt('New user....')
        # get userinfo and create new user
        access_token = parsed_response['access_token']
        @parsed_response = get_user_info(access_token, openid)

        return if parsed_response['errcode']
        SlackDispatcher.new.silent_login_attempt('Attempting to login new user...')

        auth_user
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

  def settings
    @setting ||= Setting.instance
  end

  def custom_sublayout
    "layouts/#{identity_solver.section}/submenu"
  end

  def default_layout
    "application"
  end

  def wechat_silent_solver
    @wechat_solver ||= WechatSilentConnectSolver.new(@parsed_response).resolve!
  end

  def get_access_token(code)
    url = "https://api.wechat.com/sns/oauth2/access_token?appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}&code=#{code}&grant_type=authorization_code"
    get_url(url)
  end

  def get_user_info(access_token, openid)
    url = "https://api.wechat.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}"
    get_url(url)
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

  def auth_user
    if wechat_silent_solver.success?
      sign_in_user(wechat_silent_solver.data[:customer])
    end
  end

  def sign_in_user(user)
    sign_out
    sign_in(:user, user)
  end

  def freeze_header
    @freeze_header = true
  end

  def restrict_to(section)
    unless identity_solver.section == section # :customer, :shopkeeper, :admin
      navigation.reset! # we reset to avoid infinite loop
      throw_unauthorized_page
    end
  end

end
