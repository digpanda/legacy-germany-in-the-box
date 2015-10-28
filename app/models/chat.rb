class Chat
  include Mongoid::Document
  field :name, type: String
  field :desc, type: String
  field :chat_type, type: String


  # Relations_mapping
  field :owner, :type => String
  field :chatters, :type => Array, default: []
  field :products, :type => Array, default: []
  field :products_imgs, :type => Array, default: []
  field :products_names, :type => Array, default: []
  field :collections, :type => Array, default: []
  embeds_many :messages
  belongs_to :user
  has_and_belongs_to_many :users, inverse_of: :joined_chats
end
