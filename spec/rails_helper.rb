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

RSpec.configure do |config|

  # support loads
  config.before do
    config.include Helpers::Global
    config.include Helpers::Context
    config.include Helpers::Devise
    config.include Helpers::Poltergeist
    config.include Helpers::Request
    config.include Helpers::Response
    config.include Helpers::Service

    config.include Helpers::Features::Cart
    config.include Helpers::Features::Checkout
    config.include Helpers::Features::Login
    config.include Helpers::Features::OnPage
    config.include Helpers::Features::Setting
    config.include Helpers::Features::ShowOnPage
    config.include Helpers::Features::WaitForPage

  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::TestHelpers, :type => :controller
  config.include Capybara::DSL

end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }
