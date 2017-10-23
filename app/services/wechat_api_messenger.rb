require 'wechat_api_messenger/image'
require 'wechat_api_messenger/text'
require 'wechat_api_messenger/rich'

class WechatApiMessenger < BaseService
  attr_reader :openid

  def initialize(openid:)
    @openid = openid
  end

  # NOTE : we don't memoize those methods because
  # we need a new token each time it's called.

  def image(content)
    SlackDispatcher.new.message("SENDING IMAGE NOW")
    WechatApiMessenger::Image.new(self, content)
  end

  def text(content)
    SlackDispatcher.new.message("SENDING TEXT NOW")
    WechatApiMessenger::Text.new(self, content)
  end

  def rich
    WechatApiMessenger::Rich.new(self)
  end

end
