# we make sure all is loaded to get the constants and subclasses
# we start from wechat_bot to avoid load mismatch conflicts
require 'wechat_bot'

Dir["#{File.dirname(__FILE__)}/exchange/**/*.rb"].each do |file|
  require file
end

module WechatBot
  module Exchange
  end
end
