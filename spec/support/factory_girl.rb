# RSpec
# spec/support/factory_girl.rb

RSpec.configure do |config|

  config.before do
    config.include Helpers::Global
    config.include Helpers::Request
    config.include Helpers::Response
  end

  config.include FactoryGirl::Syntax::Methods
end

# RSpec without Rails
#RSpec.configure do |config|
#  config.include FactoryGirl::Syntax::Methods

#  config.before(:suite) do
#    FactoryGirl.find_definitions
#  end
#end