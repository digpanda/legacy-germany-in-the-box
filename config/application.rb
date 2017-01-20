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
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/uploaders/concerns)

    #
    # if Rails.env.development?
    #   # this will reload the libraries we are working on
    #   # keep it within the development environment
    #   # to do not over-load production
    #   ActiveSupport::Dependencies.explicitly_unloadable_constants << "BorderGuru"
    # end

    config.middleware.use Mongoid::QueryCache::Middleware
    config.middleware.use Mobvious::Manager
    config.middleware.use HttpAcceptLanguage::Middleware
    config.i18n.available_locales = %w(de zh-CN en)
    config.i18n.default_locale = :de
    #config.time_zone = 'Beijing'

    # A loop here will make everything heavier and will force method definitions, better to keep it simple, sadly.
    config.achat = YAML.load(ERB.new(File.read(Rails.root.join("config/germany_in_the_box.yml"))).result)[Rails.env].deep_symbolize_keys!
    config.qiniu = YAML.load(ERB.new(File.read(Rails.root.join("config/qiniu.yml"))).result)[Rails.env].deep_symbolize_keys!
    config.digpanda = YAML.load(ERB.new(File.read(Rails.root.join("config/digpanda.yml"))).result)[Rails.env].deep_symbolize_keys!
    config.wirecard = YAML.load(ERB.new(File.read(Rails.root.join("config/wirecard.yml"))).result)[Rails.env].deep_symbolize_keys!
    config.border_guru = YAML.load(ERB.new(File.read(Rails.root.join("config/border_guru.yml"))).result)[Rails.env].deep_symbolize_keys!
    config.wechat = YAML.load(ERB.new(File.read(Rails.root.join("config/wechat.yml"))).result)[Rails.env].deep_symbolize_keys!

    # No environment constraint
    config.errors = YAML.load(ERB.new(File.read(Rails.root.join("config/errors.yml"))).result).deep_symbolize_keys!

    # Delayed job
    config.active_job.queue_adapter = :delayed_job

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    config.i18n.fallbacks = {'de' => 'en', 'zh-CN' => 'en'}
    config.web_console.development_only = false if Rails.env.local?
  end
end
