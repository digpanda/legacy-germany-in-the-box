class Banner
  include MongoidBase
  include Concerns::Imageable

  field :link, type: String
  field :active, type: Boolean, default: false
  field :location, type: Symbol # [:shops_landing, :package_sets_landing, ...]

  field :file, type: String
  mount_uploader :file, CoverUploader

  belongs_to :banner, polymorphic: true

  def image
    image_url(:file, :fullsize)
  end
end
