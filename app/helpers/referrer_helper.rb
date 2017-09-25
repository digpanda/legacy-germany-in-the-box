module ReferrerHelper
  def newly_published?(referrer, link)
    referrer.newly_published_links.include? link.id
  end
end
