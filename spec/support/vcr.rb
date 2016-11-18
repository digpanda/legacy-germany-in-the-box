VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'

  # your HTTP request service. You can also use fakeweb, webmock, and more
  config.hook_into :webmock
  # config.default_cassette_options = {:record => :new_episodes}
  config.configure_rspec_metadata!

  config.before_http_request(:real?) do |request|
    puts "VCR is writing #{request.method} #{request.uri}"
  end

  config.before_http_request(:stubbed?) do |request|
    puts "VCR is reading #{request.method} #{request.uri}"
  end

  # config.around_http_request do |request|
  #
  #   uri = URI(request.uri)
  #   name = "#{[uri.host, uri.path, request.method].join('/')}"
  #   VCR.use_cassette(name, &request)

    # if request.uri =~ /api.stripe.com/
    #   uri = URI(request.uri)
    #   name = "#{[uri.host, uri.path, request.method].join('/')}"
    #   VCR.use_cassette(name, &request)
    # elsif request.uri =~ /twitter.com/
    #   VCR.use_cassette('twitter', &request)
    # else
    # end

  # end

end
