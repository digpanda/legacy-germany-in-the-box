module UsersHelper

  def seems_like_a_customer?
    (current_user.nil? && chinese?) || !!(current_user&.is_customer?)
  end

  def seems_like_a_shopkeeper?
    (current_user.nil? && is_german) || !!(current_user&.is_shopkeeper?)
  end

  def seems_like_an_admin?
    current_user&.is_admin?
  end

  def german?
    I18n.locale == :de
  end

  def chinese?
    I18n.locale == :'zh-CN'
  end

end
