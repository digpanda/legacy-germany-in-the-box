
class Shop
  include Mongoid::Document

  field :name, type: String
  field :desc, type: String
  field :logo, type: String
  field :banner, type: String

  mount_uploader :logo, AttachmentUploader
  mount_uploader :banner, AttachmentUploader

  has_one :shop_info
end