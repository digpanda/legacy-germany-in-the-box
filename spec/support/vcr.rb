VCR.configure do |config|

  VCR_LOG_FILE = 'log/spec/vcr'.freeze

  config.cassette_library_dir = 'spec/vcr'

  # http request service used within the project
  config.hook_into :webmock
  # config.default_cassette_options = {:record => :new_episodes}
  config.configure_rspec_metadata!

  # writing log
  config.before_http_request(:real?) do |request|
    File.open(VCR_LOG_FILE, 'w') do |file|
      file.write("VCR is writing #{request.method} #{request.uri}")
    end
  end

  # reading log
  config.before_http_request(:stubbed?) do |request|
    File.open(VCR_LOG_FILE, 'w') do |file|
      file.write("VCR is reading #{request.method} #{request.uri}")
    end
  end

end
