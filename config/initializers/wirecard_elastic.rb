# use this to configure anything
# on the wirecard elastic api gem
Wirecard::Elastic.config do |config|

  # the engine URL must be a full URL to the elastic engine you use
  # you can add different credentials for each type of payment (Credit Card, China Union Pay, ...)
  config.creditcard = {
    :username   => ENV["wirecard_elastic_api_creditcard_username"],
    :password   => ENV["wirecard_elastic_api_creditcard_password"],
    :engine_url => ENV["wirecard_elastic_api_creditcard_engine_url"]
  }
  config.upop = {
    :username   => ENV["wirecard_elastic_api_upop_username"],
    :password   => ENV["wirecard_elastic_api_upop_password"],
    :engine_url => ENV["wirecard_elastic_api_upop_engine_url"]
  }

end
