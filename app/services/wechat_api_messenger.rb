class WechatApiMessenger < BaseService
  attr_reader :openid

  def initialize(openid:)
    @openid = openid
  end

  def image(content)
    @image ||= WechatApiMessenger::Image.new(self, content)
  end

  def text(content)
    @image ||= WechatApiMessenger::Text.new(self, content)
  end

end
