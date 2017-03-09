class Image
  include MongoidBase

  field :file, type: String
  mount_uploader :file, ImageUploader

  embedded_in :package_set

end
