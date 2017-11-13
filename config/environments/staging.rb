Rails.application.configure do

  config.cache_classes = true

  config.cache_store = :redis_store, {
    host: 'localhost',
    port: 6379,
    db: 0,
    password: ENV['redis_secret'],
    namespace: 'cache'
  }

  config.middleware.use(Mongoid::QueryCache::Middleware)
  config.eager_load = true

  config.consider_all_requests_local = false # true

  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.log_level = :debug
  config.logger = Logger.new("log/#{Rails.env}-#{Time.now.strftime('%Y-%m-%d')}.log")
  #config.force_ssl = true

  config.middleware.use ExceptionNotification::Rack,
  email: {
    email_prefix: 'Report - ',
    sender_address: %{"Bug DigPanda Staging" <notifier@digpanda.com>},
    exception_recipients: %w{laurent.schaffner@digpanda.com, jiang@digpanda.com}
  }

  # used for root_url and equivalent
  Rails.application.routes.default_url_options = { protocol: :https, host: 'www.germanyintheboxdev.com', port: 443 }

  config.action_mailer.default_url_options = { host: 'www.germanyintheboxdev.com', port: 443 }
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
end
