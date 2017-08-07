module Application
  module Language
    extend ActiveSupport::Concern

    DEFAULT_LANGUAGE = 'zh-CN'

    included do
      before_action :set_current_language
    end

    def set_current_language
      if session[:locale]
        I18n.locale = session[:locale]
      else
        I18n.locale = DEFAULT_LANGUAGE.to_sym
        session[:locale] = I18n.locale
      end
    end
  end
end
