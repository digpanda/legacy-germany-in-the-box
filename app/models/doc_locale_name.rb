module DocLocaleName

  def get_locale_name
    name_locales[I18n.locale] ? name_locales[I18n.locale] : :name
  end

end