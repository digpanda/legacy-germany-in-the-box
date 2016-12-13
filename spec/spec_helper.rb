RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do
    Mongoid.purge!
  end
end

Capybara.app_host = "http://local.dev:3333"
Capybara.always_include_port = true
Capybara.default_host = "http://local.dev:3333"
Capybara.server_port = 3333
Capybara.server_host = "local.dev"
# Capybara.run_server = false
Capybara.default_max_wait_time = 80

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

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end
#
Capybara.ignore_hidden_elements = true
# END POLTERGEIST

# Capybara.current_session.driver.resize(1200, 1000)

# we turn VCR off by default because we don't want to use it systematically
VCR.turn_off!
WebMock.allow_net_connect!
# WebMock.disable_net_connect!
