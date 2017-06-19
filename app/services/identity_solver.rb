# anything related to the section (customer, shopkeeper, admin)
# and used within the controller or model, etc. are defined here
# NOTE : maybe we should include LandingSolver in the IdentitySolver for constitency
class IdentitySolver < BaseService

  include Rails.application.routes.url_helpers

  attr_reader :request, :session, :user

  def initialize(request, session, user)
    @request = request
    @session = session
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
    SlackDispatcher.new.message("LANDING URL WAS USED `#{landing_url}`")
    landing_url
    #wechat_customer? ? guest_package_sets_path : root_path
  end

  def landing_url
    @landing_url ||= LandingSolver.new(request).recover
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
