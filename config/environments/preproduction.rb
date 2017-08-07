Rails.application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.force_ssl = false
  config.log_level = :debug
  config.logger = Logger.new("log/#{Rails.env}-#{Time.now.strftime('%Y-%m-%d')}.log")

  config.middleware.use ExceptionNotification::Rack,
  email: {
    :email_prefix => "Report - ",
    :sender_address => %{"Bug DigPanda Production" <notifier@digpanda.com>},
    :exception_recipients => %w{laurent.schaffner@digpanda.com, jiang@digpanda.com}
  }

  # used for root_url and equivalent
  Rails.application.routes.default_url_options = {protocol: :https, host: 'www.germanyinthebox.com', port: 443}

  config.action_mailer.default_url_options = {host: 'www.germanyinthebox.com', port: 443}

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #     address: "smtp.mailgun.org",
  #     port: 587,
  #     domain: 'gmail.com',
  #     authentication: "plain",
  #     enable_starttls_auto: true,
  #     user_name: 'germanyinthebox@gmail.com',
  #     password: 'pandarocks'
  #   }

  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
          api_key: 'key-57fccf0c1fa0bf601a25865e43e0f742',
          domain: 'germanyinthebox.de'
  }


  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  # config.adyen.environment = 'test'
  # config.adyen.api_username = 'ws@Company.Digpanda'
  # config.adyen.api_password = 'EfAwI[iH=%sVKX^Hb3X!4^z4>'

end
