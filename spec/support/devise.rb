RSpec.configure do |config|
  config.include Devise::TestHelpers #, type: :controller
  config.include Warden::Test::Helpers #, type: :request
  config.include ControllerHelpers #, type: :controller

  config.before(:each) do
    Warden.test_mode!
  end
  config.after(:each) do
    Warden.test_reset!
  end

end
