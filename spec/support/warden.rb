RSpec.configure do |config|

  config.include Warden::Test::Helpers
  config.before(:each) do
    Warden.test_mode!
  end
  config.after(:each) do
    Warden.test_reset!
  end

end
