RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do

    Mongoid.purge!
    #sign_out :user
  end
end
