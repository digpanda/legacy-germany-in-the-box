module UsersHelper

  def seems_like_a_customer?
    current_user.nil? || current_user.is_customer?
  end

  def is_german?
    I18n.locale == :de
  end

  def is_chinese?
    I18n.locale == :'zh-CN'
  end

end
