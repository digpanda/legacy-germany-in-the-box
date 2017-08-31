class Link
  include MongoidBase
  include Mongoid::Search

  field :title, type: String
  field :desc, type: String
  field :long_desc, type: String
  field :thumbnail_url, type: String

  field :raw_url, type: String
  field :valid_url, type: Boolean, default: true
  field :active, type: Boolean, default: false

  field :published_at, type: Time

  field :position, type: Integer, default: 0

  scope :active, -> { where(active: true) }

  # research system
  search_in :title, :url

  before_save :ensure_published_at

  def wechat
    @wechat ||= WechatLinkCreator.new(self)
  end

  def newly_published?
    active && (published_at.utc.to_i == Time.now.utc.to_i)
  end

  private
    def ensure_published_at
      if active && !published_at
        self.published_at = Time.now
      end
    end
end
