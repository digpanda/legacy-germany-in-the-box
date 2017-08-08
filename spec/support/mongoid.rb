RSpec.configure do |config|
  Mongoid.load!(Rails.root.join('config', 'mongoid.yml'))
end
