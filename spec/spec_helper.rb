RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do
    Mongoid.purge!
  end
end

require "selenium/webdriver"

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)

  args = []
  args << "--window-size=1400,1000" # window size

  Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)

end

#Capybara.app_host =  "http://local.dev:3000"
#Capybara.run_server = false
#Capybara.current_driver = :selenium
Capybara.default_max_wait_time = 30

# we turn VCR off by default because we don't want to use it systematically
VCR.turn_off!
WebMock.allow_net_connect!
# WebMock.disable_net_connect!
