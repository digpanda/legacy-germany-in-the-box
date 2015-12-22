class Post
  include Mongoid::Document

  field :name, type: String
  field :image, type: String
  field :productId, type: String
  field :collectionId, type: String
  field :chatId, type: String

  mount_uploader :image, AttachmentUploader

  validates :name, :image, presence: true

  belongs_to :user
end

