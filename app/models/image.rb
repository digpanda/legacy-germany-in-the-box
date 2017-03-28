class Image
  include MongoidBase

  field :file, type: String
  mount_uploader :file, ImageUploader

  belongs_to :image, polymorphic: true

end
