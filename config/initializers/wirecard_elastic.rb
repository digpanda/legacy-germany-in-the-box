# use this to configure anything
# on the wirecard elastic api gem
Wirecard::Elastic.config do |config|

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
