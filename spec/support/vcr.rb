VCR.configure do |config|

  # we quickly setup a logger for it
  # NOTE : we can't really setup the logger with daily file
  # becaue the process is kind of recreating a file all the time
  logger = Logger.new("#{Rails.root}/log/vcr-#{Time.now.strftime('%Y-%m-%d')}.log")

  config.cassette_library_dir = 'spec/vcr'

  # http request service used within the project
  config.hook_into :webmock
  # config.default_cassette_options = {:record => :new_episodes}
  config.configure_rspec_metadata!

  # writing log
  config.before_http_request(:real?) do |request|
    logger.info "VCR is writing #{request.method} #{request.uri}"
  end

  # reading log
  config.before_http_request(:stubbed?) do |request|
    logger.info "VCR is reading #{request.method} #{request.uri}"
  end

end
