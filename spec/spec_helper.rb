# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise 'foo'
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:
    require "spec/spec_helper"
  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.
  Loaded this time from:
    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

RSpec.configure do |config|

  config.use_transactional_fixtures = false
  config.mock_with :rspec
  config.before(:each) do
    Mongoid.purge!
    Setting.create!
    5.times do |time|
      FactoryGirl.create(:shipping_rate, partner: :beihai, weight: (10 * time), price: (4 * time))
      FactoryGirl.create(:shipping_rate, partner: :mkpost, weight: (10 * time), price: (4 * time))
    end
    page.driver.reset!
    # VCR.turn_on!
  end

  config.before(:each, js: true) do

      WebMock.stub_request(:get, /alipaydev.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "stubbed response", headers: {})

      WebMock.stub_request(:get, /api.twilio.com:443/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "stubbed response", headers: {})

      # rspec ./spec/controllers/guest/referrers_controller_spec.rb:8 # Guest::ReferrersController#qrcode should respond with numeric status code 200
      # rspec ./spec/features/checkout_process_spec.rb:22 # checkout process with mkpost logistic partner pays successfully with alipay
      # rspec ./spec/features/checkout_process_spec.rb:70 # checkout process with manual logistic address built from scratch pay successfully and generate shipping label correctly
      # rspec ./spec/features/checkout_process_spec.rb:79 # checkout process with manual logistic address already setup fail to pay
      # rspec ./spec/features/checkout_process_spec.rb:85 # checkout process with manual logistic address already setup apply a coupon pay successfully and generate shipping label correctly with coupon
      # rspec ./spec/features/package_set_process_spec.rb:13 # package set process get a package set and go to checkout
      # rspec ./spec/features/package_set_process_spec.rb:21 # package set process get a package set, apply a coupon and go to checkout
      # rspec ./spec/services/event_dispatcher_spec.rb:8 # EventDispatcher#customer_signed_in register an a sign-in event with geo
      # rspec ./spec/services/notifier/dispatcher_spec.rb:50 # Notifier::Dispatcher#perform should send a SMS
      # rspec ./spec/services/notifier/dispatcher_spec.rb:63 # Notifier::Dispatcher#perform should not send a SMS
      # rspec ./spec/services/notifier/dispatcher_spec.rb:77 # Notifier::Dispatcher#perform should send a SMS and an email

    # page.driver.browser.url_blacklist = ["https://openapi.alipaydev.com/", "https://alipaydev.com", "http://alipaydev.com"]
  end

  # Add VCR to all tests
  # config.around(:each) do |example|
  #   VCR.turn_on!
  #   options = example.metadata || {}
  #   if options[:vcr] == :skip
  #     VCR.turn_off!
  #     VCR.turned_off(&example)
  #     page.driver.reset!
  #     example.run
  #   else
  #     name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
  #     VCR.use_cassette(name, options, &example)
  #   end
  #   VCR.turn_off!
  # end

end

VCR.turn_off!

port = 3333 + ENV['TEST_ENV_NUMBER'].to_i # for `parallel_tests`
host = 'local.dev'

Capybara.app_host = "http://#{host}:#{port}"
Capybara.always_include_port = true
Capybara.default_host = "http://#{host}:#{port}"
Capybara.server_port = port
Capybara.server_host = host
# Capybara.run_server = false
Capybara.default_max_wait_time = 15

# BEGINNING SELENIUM
# require "selenium/webdriver"
# Capybara.current_driver = :selenium
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
#
#   args = []
#   args << "--window-size=1400,1000" # window size
#
#   Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)
# end
# END SELENIUM

# BEGINNING POLTERGEIST
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

# take screenshot
# page.driver.render("/tmp/file_#{Time.now.to_i}.jpg", :full => true)

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    js_errors: false,
                                    debug: false,
                                    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--local-to-remote-url-access=no'],
                                    # phantomjs_options: ["--debug=yes"],
                                    window_size: [1800, 1000],
                                    port: 51674 + ENV['TEST_ENV_NUMBER'].to_i # `parallel_tests`
                                    )
end
#
Capybara.ignore_hidden_elements = false
# END POLTERGEIST
#
# we turn VCR off by default because we don't want to use it systematically
# VCR.turn_off!
WebMock.allow_net_connect!
# WebMock.disable_net_connect!

#Capybara.current_session.driver.resize(3000, 1300)
