Rails.application.configure do

  config.cache_classes = false
  config.middleware.use(Mongoid::QueryCache::Middleware)
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  # used for root_url and equivalent
  Rails.application.routes.default_url_options = {host: 'local.dev', port: 3000}

  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
          api_key: 'key-57fccf0c1fa0bf601a25865e43e0f742',
          domain: 'sandboxf507885e459a4b7484539fc0cbcf144a.mailgun.org'
  }

=begin
  config.action_mailer.smtp_settings = {
      address: "mailtrap.io",
      port: 25,
      domain: 'mailtrap.io',
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: 'f396f41db34e22',
      password: 'f4eede72e026e4'
  }
=end
end
