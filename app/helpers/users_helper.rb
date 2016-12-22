module UsersHelper

  def user_roles
    [['Administrator', :admin],['Shopkeeper', :shopkeeper],['Customer', :customer]]
  end
  def potential_customer?
    (current_user.nil? && chinese?) || !!(current_user&.decorate&.customer?)
  end

  def potential_shopkeeper?
    (current_user.nil? && german?) || !!(current_user&.decorate&.shopkeeper?)
  end

  def potential_admin?
    current_user&.decorate&.admin?
  end

  # put this into language ?
  def german?
    I18n.locale == :de
  end

  def chinese?
    I18n.locale == :'zh-CN'
  end

  def chinese_ip?
    Geocoder.search($request.remote_ip).first.country_code == 'CN'
  end

end
