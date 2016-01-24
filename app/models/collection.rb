class Collection
  include Mongoid::Document

  field :name, type: String
  field :desc, type: String
  field :visible, type: String
  field :coltype, type: String
  field :img, type: String
  field :public, type: Boolean

  # Relations
  has_and_belongs_to_many :users, inverse_of: :collections
  has_and_belongs_to_many :products, inverse_of: :collections
  belongs_to :user, inverse_of: :oCollections

  # Validations
  validates :name, presence: true

  mount_uploader :img, AttachmentUploader


  protected

  def getuser
    @owner = User.find(self.owner)
    self.owner_img = @owner.pic
    self.owner_name = @owner.username
  end
end
