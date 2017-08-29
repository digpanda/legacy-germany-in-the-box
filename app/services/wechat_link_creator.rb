class WechatLinkCreator
  include Rails.application.routes.url_helpers

  attr_reader :link

  def initialize(link)
    @link = link
  end

  # NOTE : this system used to be more complex
  # we kept the library in case it gets complicated again
  # for now it's just a simple path
  # Laurent, 29/08/2017
  def with_referrer(referrer)
    guest_link_url(link, reference_id: referrer&.reference_id)
  end

end
