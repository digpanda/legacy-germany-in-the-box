#ENV["RAILS_ENV"] ||= 'test'
#require File.expand_path("../../config/environment", FILE)

RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do
    #Mongoid.purge!
    #sign_out :user
  end
end
