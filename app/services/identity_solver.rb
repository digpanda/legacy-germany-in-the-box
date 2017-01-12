# anything related to the section (customer, shopkeeper, admin)
# and used within the controller or model, etc. are defined here
class IdentitySolver

  attr_reader :request, :user

  def initialize(request, user)
    @request = request
    @user = user
  end

  def section
    if potential_customer?
      :customer
    elsif potential_shopkeeper?
      :shopkeeper
    elsif potential_admin?
      :admin
    end
  end

  def potential_customer?
    (user.nil? && chinese?) || !!(user&.decorate&.customer?)
  end

  def potential_shopkeeper?
    (user.nil? && german?) || !!(user&.decorate&.shopkeeper?)
  end

  def potential_admin?
    user&.decorate&.admin?
  end

  def german?
    I18n.locale == :de
  end

  def chinese?
    I18n.locale == :'zh-CN'
  end

  def chinese_ip?
    Geocoder.search(request.remote_ip).first&.country_code == 'CN'
  end

end
