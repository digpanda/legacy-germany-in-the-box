# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# HAML escape attrs
# Haml::Template.options[:escape_attrs] = false -> this blows up the current template system
