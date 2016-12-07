RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# deactivate the ActiveRecord fixtures
module ActiveRecord::TestFixtures
  def before_setup
    super
  end

  def after_teardown
    super
  end
end
