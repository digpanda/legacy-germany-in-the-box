class WechatLinkCreator
  include Rails.application.routes.url_helpers

  attr_reader :link

  def initialize(link)
    @link = link
  end

  # generate a link for the guest/links#weixin which will redirect to the weixin auto-login and bind to referrer
  # and then redirect to links#show which will go somewhere else
  def with_login_and_referrer(referrer)
    raw_url = url_for(:action => 'weixin', :link_id => link.id, :controller => 'guest/links', :host => 'germanyinbox.com', :protocol => 'https', :reference_id => referrer&.reference_id)
  end

  def with_referrer(referrer)
    raw_url = url_for(:action => 'show', :id => link.id, :controller => 'guest/links', :host => 'germanyinbox.com', :protocol => 'https', :reference_id => referrer&.reference_id)
    WechatUrlAdjuster.new(raw_url).adjusted_url
  end

end
