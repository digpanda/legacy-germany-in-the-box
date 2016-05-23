Rails.application.configure do


  config.cache_classes = true
  config.middleware.use(Mongoid::QueryCache::Middleware)
  config.eager_load = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  #config.force_ssl = true


  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "Report - ",
    :sender_address => %{"Bug DigPanda Staging" <notifier@digpanda.com>},
    :exception_recipients => %w{laurent.schaffner@digpanda.com, jiang@digpanda.com, dailycron@hotmail.com}
  }

  config.action_mailer.default_url_options = {host: 'germanyinthebox.com', port: 80}
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: 'gmail.com',
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: 'germanyinthebox@gmail.com',
      password: 'pandarocks'
  }

end
