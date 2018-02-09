require 'wechat_api/messenger/image'
require 'wechat_api/messenger/text'
require 'wechat_api/messenger/rich'

class WechatApi::Messenger < BaseService
  attr_reader :openid

  def initialize(openid:)
    @openid = openid
  end

  # NOTE : we don't memoize those methods because
  # we need a new token each time it's called.

  def image(content)
    WechatApi::Messenger::Image.new(self, content)
  end

  def text(content)
    WechatApi::Messenger::Text.new(self, content)
  end

  def rich
    WechatApi::Messenger::Rich.new(self)
  end

  # NOTE : Prima Donna Methods
  # shortcut to spawn directly the request

  def image!(content)
    image(content).send
  end

  def text!(content)
    text(content).send
  end
end
