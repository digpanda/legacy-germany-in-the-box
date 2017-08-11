class WechatLinkCreator
  include Rails.application.routes.url_helpers

  attr_reader :link

  def initialize(link)
    @link = link
  end

  def with_referrer(referrer)
    raw_url = guest_link_path(link, reference_id: referrer.reference_id)
    WechatUrlAdjuster.new(raw_url).adjusted_url
  end

end
