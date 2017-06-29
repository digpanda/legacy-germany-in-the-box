# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
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

  #config.include Rack::Test::Methods
  config.use_transactional_fixtures = false
  config.mock_with :rspec
  config.before(:each) do
    Mongoid.purge!
    Setting.create!
    5.times do |time|
      FactoryGirl.create(:shipping_rate, partner: :beihai, weight: (10 * time), price: (4 * time))
      FactoryGirl.create(:shipping_rate, partner: :mkpost, weight: (10 * time), price: (4 * time))
      FactoryGirl.create(:shipping_rate, partner: :xipost, weight: (10 * time), price: (4 * time))
    end
    page.driver.reset!
  end

end

Capybara.app_host = "http://local.dev:3333"
Capybara.always_include_port = true
Capybara.default_host = "http://local.dev:3333"
Capybara.server_port = 3333
Capybara.server_host = "local.dev"
# Capybara.run_server = false
Capybara.default_max_wait_time = 50

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
                                    :js_errors => false,
                                    :debug => false,
                                    # :phantomjs_options => ["--debug=yes"],
                                    :window_size => [1800,1000],
                                    )
end
#
Capybara.ignore_hidden_elements = false
# END POLTERGEIST
#
# we turn VCR off by default because we don't want to use it systematically
VCR.turn_off!
WebMock.allow_net_connect!
# WebMock.disable_net_connect!

#Capybara.current_session.driver.resize(3000, 1300)
