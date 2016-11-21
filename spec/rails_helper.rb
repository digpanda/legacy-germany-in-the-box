ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'pry'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'mongoid'
require 'devise'
require 'faker'
require 'vcr'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }


RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::TestHelpers, :type => :controller
  config.include Capybara::DSL
end
