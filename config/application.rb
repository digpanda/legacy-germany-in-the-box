require File.expand_path('../boot', __FILE__)

require 'rails'

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
require 'mobvious'
require 'http_accept_language'
require "i18n/backend/fallbacks"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DigPanda
  class Application < Rails::Application

    config.exceptions_app = self.routes # customized error handling

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/services)
    
    config.middleware.use Mongoid::QueryCache::Middleware
    config.middleware.use Mobvious::Manager
    config.middleware.use HttpAcceptLanguage::Middleware
    config.i18n.available_locales = %w(de zh-CN en)
    config.i18n.default_locale = :de
    #config.time_zone = 'Beijing'
    
    # A loop here will make everything heavier and will force method definitions, better to keep it simple, sadly.
    config.digpanda = YAML.load_file(Rails.root.join("config/digpanda.yml"))[Rails.env].deep_symbolize_keys!
    config.wirecard = YAML.load_file(Rails.root.join("config/wirecard.yml"))[Rails.env].deep_symbolize_keys!
    config.border_guru = YAML.load_file(Rails.root.join("config/border_guru.yml"))[Rails.env].deep_symbolize_keys!
    config.wechat = YAML.load_file(Rails.root.join("config/wechat.yml"))[Rails.env].deep_symbolize_keys!

    # No environment constraint
    config.errors = YAML.load_file(Rails.root.join("config/errors.yml")).deep_symbolize_keys!

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    config.i18n.fallbacks = {'de' => 'en', 'zh-CN' => 'en'}
    config.web_console.development_only = false if Rails.env.local?
  end
end