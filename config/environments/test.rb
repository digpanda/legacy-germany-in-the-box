Rails.application.configure do

  config.cache_classes = true
  config.eager_load = false

  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'

  config.consider_all_requests_local = false # true <-- test production behavior
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = true

  config.action_controller.allow_forgery_protection = false

  config.active_support.test_order = :random
  config.active_support.deprecation = :stderr

  config.action_mailer.default_url_options = { host: 'germanyinthebox.com', port: 80 }
  config.action_mailer.delivery_method = :test #:smtp

  # used for root_url and equivalent
  Rails.application.routes.default_url_options = { host: 'local.dev', port: 3333 }

  OmniAuth.config.test_mode = true

  #
  # config.action_mailer.smtp_settings = {
  #     address: "mailtrap.io",
  #     port: 25,
  #     domain: 'mailtrap.io',
  #     authentication: "plain",
  #     enable_starttls_auto: true,
  #     user_name: 'f396f41db34e22',
  #     password: 'f4eede72e026e4'
  # }

end
