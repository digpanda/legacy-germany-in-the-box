module LanguagesHelper

  DEFAULT_LANGUAGE = "zh-CN"

  def set_current_language
    if session[:locale]
      I18n.locale = session[:locale]
    else
      I18n.locale = DEFAULT_LANGUAGE.to_sym
      session[:locale] = I18n.locale
    end
  end

  # Not 100% sure it's used in the system, but it's called at some point
  def set_translation_locale
    current_locale = I18n.locale
    I18n.locale = params[:translation].to_sym if params[:translation]
    yield
  ensure
    I18n.locale = current_locale
  end

  def force_german!
    session[:locale] = :de
    I18n.locale = session[:locale]
  end

end
