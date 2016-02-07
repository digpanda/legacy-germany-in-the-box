class Collection
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes :only => [:name, :desc]

  field :name, type: String
  field :desc, type: String
  field :coltype, type: String
  field :img, type: String
  field :public, type: Boolean, default: true

  mount_uploader :img, AttachmentUploader

  has_and_belongs_to_many :users, inverse_of: :collections
  has_and_belongs_to_many :products, inverse_of: :collections
  belongs_to :user, inverse_of: :oCollections

  validates :name,    presence: true
  validates :public,  presence: true
  validates :user,    presence: true

  scope :public, -> { where(:public => true) }
end
