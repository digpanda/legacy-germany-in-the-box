module DocLocaleName

  def get_locale_name
    name_locales ? (name_locales[I18n.locale] ? name_locales[I18n.locale] : :name) : :name
  end

end