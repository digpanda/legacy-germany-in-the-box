# we make sure all is loaded to get the constants and subclasses
# we start from wechat_bot to avoid load mismatch conflicts
Dir["#{File.dirname(__FILE__)}/wechat_bot/**/*.rb"].each do |file|
  puts "requiring #{file}"
  require file
end

module WechatBot
end
