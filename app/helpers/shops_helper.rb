module ShopsHelper

  def get_allowed_locales
    if current_user&.decorate&.admin?
      %W(zh-CN, de).map(&:to_sym)
    else
      [I18n.locale]
    end
  end

end
