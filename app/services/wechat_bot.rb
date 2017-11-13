# we make sure all is loaded to get the constants and subclasses
# we start from wechat_bot to avoid load mismatch conflicts
unless Rails.env.staging? || Rails.env.production?
  # no auto load if dev or test
  Dir["#{File.dirname(__FILE__)}/wechat_bot/**/*.rb"].each do |file|
    require file
  end
end

module WechatBot
end
