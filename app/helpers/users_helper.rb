module UsersHelper

  # improve this system ?
  def seems_like_a_customer?
    (current_user.nil? && chinese?) || !!(current_user&.decorate&.customer?)
  end

  def seems_like_a_shopkeeper?
    (current_user.nil? && german?) || !!(current_user&.decorate&.shopkeeper?)
  end

  def seems_like_an_admin?
    current_user&.decorate&.admin?
  end

  # put this into language ?
  def german?
    I18n.locale == :de
  end

  def chinese?
    I18n.locale == :'zh-CN'
  end

end
