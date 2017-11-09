# we make sure all is loaded to get the constants and subclasses
Dir["#{File.dirname(__FILE__)}/exchange/**/*.rb"].each {|file| load file}
# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
module WechatBot
  module Exchange
  end
end
