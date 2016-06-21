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

module AChat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true
    
    #config.assets.precompile = []
    
    # Customized error handling
    config.exceptions_app = self.routes

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/services)
    
    config.middleware.use Mongoid::QueryCache::Middleware
    config.middleware.use Mobvious::Manager
    config.middleware.use HttpAcceptLanguage::Middleware
    config.i18n.available_locales = %w(de zh-CN en)
    config.i18n.default_locale = :de
    #config.time_zone = 'Beijing'
    %W(wirecard digpanda border_guru).each do |config_file|
        config.define_singleton_method "#{config_file}", -> { @config ||= YAML.load_file("#{Rails.root.to_s}/config/#{config_file}.yml")[Rails.env].deep_symbolize_keys! }
    end

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    config.i18n.fallbacks = {'de' => 'en', 'zh-CN' => 'en'}
    config.web_console.development_only = false if Rails.env.local?
  end
end