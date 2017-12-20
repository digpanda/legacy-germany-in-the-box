Rails.application.configure do

  # NOTE : when working on cache, please set those to true
  # - Laurent
  config.cache_classes = false

  config.action_controller.perform_caching = true
  # config.cache_store = :null_store
  config.cache_store = :file_store, "#{Rails.root}/public/cache"
  config.cache_store = :redis_store, {
    host: 'localhost',
    port: 6379,
    db: 0,
    password: ENV['redis_secret'],
    namespace: 'cache'
  }

  config.middleware.use Mongoid::QueryCache::Middleware
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  # used for root_url and equivalent
  Rails.application.routes.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      address: 'mailtrap.io',
      port: 25,
      domain: 'mailtrap.io',
      authentication: 'plain',
      enable_starttls_auto: true,
      user_name: 'f396f41db34e22',
      password: 'f4eede72e026e4'
  }

  # Mini profiler activation, please comment to disable
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
