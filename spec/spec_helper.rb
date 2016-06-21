RSpec.configure do |config|

  config.mock_with :rspec
  config.before(:each) do

    Mongoid.purge!

  end
end
