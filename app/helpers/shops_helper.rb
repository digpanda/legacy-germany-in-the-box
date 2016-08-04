module ShopsHelper

  def get_allowed_locales
    if current_user&.decorate&.admin?
      %w(zh-CN, de).each(&:symbolize_keys)
    else
      [I18n.locale]
    end
  end

end
