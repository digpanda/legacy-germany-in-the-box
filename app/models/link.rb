class Link
  include MongoidBase
  include Mongoid::Search

  field :title, type: String
  field :desc, type: String
  field :long_desc, type: String
  field :thumbnail_url, type: String

  field :raw_url, type: String
  field :valid_url, type: Boolean, default: true

  field :position, type: Integer, default: 0

  # research system
  search_in :title, :url

  def wechat
    @wechat ||= WechatLinkCreator.new(self)
  end
end
