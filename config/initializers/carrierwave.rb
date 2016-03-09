CarrierWave.configure do |config|
  config.storage = :file
  #config.asset_host = ActionDispatch::Http::URL.url_for(ActionMailer::Base.default_url_options)
end
