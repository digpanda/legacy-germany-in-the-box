RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do
    Mongoid.purge!
  end
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

#Capybara.app_host =  "http://local.dev:3000"
#Capybara.run_server = false
#Capybara.current_driver = :selenium

# we turn VCR off by default because we don't want to use it systematically
VCR.turn_on!
# WebMock.allow_net_connect!
# WebMock.disable_net_connect!
