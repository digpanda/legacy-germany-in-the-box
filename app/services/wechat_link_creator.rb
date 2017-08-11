class WechatLinkCreator
  include Rails.application.routes.url_helpers

  attr_reader :link

  def initialize(link)
    @link = link
  end

  def with_referrer(referrer)
    raw_url = url_for(:action => 'index', :controller => 'guest/links', :host => 'germanyinbox.com', :protocol => 'https', :reference_id => referrer.reference_id)
    WechatUrlAdjuster.new(raw_url).adjusted_url
  end

end
