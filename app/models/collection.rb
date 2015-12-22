class Collection
  include Mongoid::Document

  field :name, type: String
  field :desc, type: String
  field :visible, type: String
  field :coltype, type: String
  field :img, type: String


  # Relations_mapping
  # field :owner, :type => String

  # field :private_chats, :type => Array, default: []
  # field :public_chats, :type => Array, default: []


  # Relations
  has_and_belongs_to_many :users, inverse_of: :collections
  has_and_belongs_to_many :products, inverse_of: :collections
  belongs_to :user, inverse_of: :oCollections
  # belongs_to :owner ,class_name: "User"
  # has_many :likers, class_name: "User" , as: "likers"
  # has_many :products , class_name: "Product" , as: 'products'

  # callbacks
  # before_save :getuser


  protected

  def getuser
    @owner = User.find(self.owner)
    self.owner_img = @owner.pic
    self.owner_name = @owner.username
  end

end
