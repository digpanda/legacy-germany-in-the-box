# anything related to the section (customer, shopkeeper, admin)
# and used within the controller or model, etc. are defined here
class IdentitySolver < BaseService

  include Rails.application.routes.url_helpers

  attr_reader :request, :session, :user

  def initialize(request, user)
    @request = request
    @session = request.session
    @user = user
  end

  def section
    if potential_admin?
      :admin
    elsif potential_shopkeeper?
      :shopkeeper
    elsif potential_customer? || guest_section?
      :customer
    end
  end

  def wechat_customer?
    session[:origin] == :wechat
  end

  def origin_url
    landing_url
  end

  def origin_setup!
    return session[:origin] if session[:origin]
    if chinese_domain? || wechat_browser?
      session[:origin] = :wechat
    else
      session[:origin] = :browser
    end
  end

  def landing_url
    @landing_url ||= landing_solver.recover
  end

  def landing_solver
    @landing_solver ||= LandingSolver.new(request)
  end

  def potential_customer?
    (user.nil? && chinese?) || !!(user&.customer?)
  end

  def potential_shopkeeper?
    (user.nil? && german?) || !!(user&.shopkeeper?)
  end

  def potential_admin?
    user&.decorate&.admin?
  end

  def wechat_browser?
    request.user_agent&.include? "MicroMessenger"
  end

  def chinese_domain?
    request.url&.include? "germanyinbox.com"
  end

  def guest_section?
    request.url.include? "/guest/"
  end

  def german?
    I18n.locale == :de
  end

  def chinese?
    I18n.locale == :'zh-CN'
  end

  def chinese_ip?
    @chinese_ip ||= Geocoder.search(request.remote_ip).first&.country_code == 'CN'
  end

  def german_ip?
    @german_ip ||= Geocoder.search(request.remote_ip).first&.country_code == 'DE'
  end

end
