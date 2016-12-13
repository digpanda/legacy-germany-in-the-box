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

  before_action :setup_request
  helper_method :cart_manager

  # this variable setup is very sensitive
  # we use it in exceptional context
  # please be aware of how it works before to use it
  def setup_request
    $request = request
  end


  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  def navigation
    @navigation ||= NavigationHistory.new(request, session)
  end

  def cart_manager
    @cart_manager ||= CartManager.new(session, current_user)
  end

  def custom_sublayout
    "sublayout/_menu"
  end

end
