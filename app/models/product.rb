class Product
  include Mongoid::Document
  field :network, type: String
  field :shopname, type: String
  field :prodid, type: String
  field :deeplink, type: String
  field :name, type: String
  field :brand, type: String
  field :category, type: String
  field :img, type: String
  field :imglg, type: String
  field :price
  field :priceold
  field :sale, type: Integer
  field :currency, type: String
  field :update_, type: String
  field :status, type: String
  field :desc, type: String
  
  # Relations_mapping
  field :owner, :type => String
  field :likers, :type => Array, default: []
  field :private_chats, :type => Array, default: []
  field :public_chats, :type => Array, default: []

  # # Relations
  has_and_belongs_to_many :users, inverse_of: :products
  has_and_belongs_to_many :collections, inverse_of: :products
  belongs_to :user, inverse_of: :oProcuts
  # has_many :likers, class_name: "User" , as: 'likers'

  embedded_in :shop

  index({brand: 1}, {unique: false})
  index({category: 1}, {unique: false})
  index({name: 1}, {unique: false})

  # search_in :brand, :name, :desc

  def owner_img
    "test"
  end

  def owner_name
    "test"
  end

end