class Banner
  include MongoidBase
  include Mongoid::Search
  include Concerns::Imageable

  search_in :id, :link, :active, :location

  # TODO : don't forget to cut off domain if it's local
  field :link, type: String
  field :active, type: Boolean, default: false
  field :location, type: Symbol # [:shops_landing_cover, :package_sets_landing_cover, ...]

  field :cover, type: String
  mount_uploader :cover, CoverUploader

  belongs_to :banner, polymorphic: true

  scope :active, -> { self.and(active: true) }

  def image
    image_url(:cover, :fullsize)
  end
end
