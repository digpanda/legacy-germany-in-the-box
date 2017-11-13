# we make sure all is loaded to get the constants and subclasses
require 'wechat_bot'
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require file
end

module WechatBot
  module Exchange
  end
end
