class Collection
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,    type: String
  field :img,     type: String
  field :public,  type: Boolean, default: true
  field :desc,    type: String

  field :name_locales, type: Hash

  mount_uploader :img, AttachmentUploader

  has_and_belongs_to_many :users,     inverse_of: :liked_collections
  has_and_belongs_to_many :products,  inverse_of: :collections

  belongs_to :user, inverse_of: :oCollections

  validates :name,    presence: true, length: {maximum: Rails.configuration.max_short_text_length}
  validates :public,  presence: true
  validates :user,    presence: true
  validates :desc,    length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}

  scope :is_public, -> { where(:public => true) }
end
