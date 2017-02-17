# anything related to the section (customer, shopkeeper, admin)
# and used within the controller or model, etc. are defined here
class IdentitySolver < BaseService

  attr_reader :request, :user

  def initialize(request, user)
    @request = request
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
    @german_ip ||= begin
      Geocoder.search(request.remote_ip).first&.country_code == "DE"
      #SlackDispatcher.new.message("GEOCODER STARTED FOR IP RECOGNITION")
      #Geocoder.search(request.remote_ip).first&.country_code == 'DE'
      # SlackDispatcher.new.message("GEOCODER STARTED FOR IP RECOGNITION")
      # country_code = Geocoder.search(request.remote_ip).first&.country_code
      # SlackDispatcher.new.message("IP IS #{request.remote_ip} AND WAS SOLVED")
      # country_code == 'DE'
    end
  end

end
