class Image
  include MongoidBase
  include Concerns::Imageable

  field :file, type: String
  mount_uploader :file, ImageUploader

  belongs_to :image, polymorphic: true

  field :url, type: String

  def thumb
    image_url(:file, :thumb)
  end

  def fullsize
    image_url(:file, :fullsize)
  end
end
