RSpec.configure do |config|
  config.before do
    config.include Helpers::Global
    config.include Helpers::Context
    config.include Helpers::Request
    config.include Helpers::Response
  end
end
