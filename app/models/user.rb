class User
  include Mongoid::Document

  field :username, type: String
  field :email, type: String
  field :fname, type: String
  field :lname, type: String
  field :birth, type: String
  field :gender, type: String
  field :about, type: String
  field :website, type: String
  field :country, type: String
  field :pic, type: String
  field :lang, type: String
  field :parse_id, type: String
  field :provider
  field :uid

  field :tel
  field :mobile

  mount_uploader :pic, AttachmentUploader

  acts_as_token_authenticatable
  field :authentication_token

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  devise :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
   field :confirmation_token,   type: String
   field :confirmed_at,         type: Time
   field :confirmation_sent_at, type: Time
   field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # Relations_mapping
  # field :followers , :type => Array , default: []
  # field :following , :type => Array , default: []
  # field :saved_collections , :type => Array , default: []
  # field :saved_products , :type => Array , default: []
  # field :private_chats , :type => Array , default: []
  # field :public_chats , :type => Array , default: []
  field :notifications , :type => Array , default: []


  # # Relations
  has_and_belongs_to_many :followers, :class_name => 'User', :inverse_of => :following
  has_and_belongs_to_many :following, :class_name => 'User', :inverse_of => :followers

  has_and_belongs_to_many :products, :class_name => 'Product', inverse_of: :users
  has_and_belongs_to_many :collections ,:class_name => 'Collection' , inverse_of: :users
  has_many :oProducts , class_name: 'Product',inverse_of: :user

  has_many :posts

  has_many :chats

  has_many :joined_chats , class_name: 'Chat', inverse_of: :users

  has_many :oCollections , class_name: 'Collection' ,inverse_of: :user

  has_many :orders;

  has_many :addresses;

  # has_many :liked_collections, class_name: "Collection"

  # Validatons
  validates :username  , :email , presence: true
  validates :email , uniqueness: true
  # validates :fname, presence: true
  # validates :lname, presence: true
  #validates :birth, presence: true
  #validates :gender, presence: true
  # validates :about, presence: true
  # validates :website, presence: true
  # validates :country, presence: true
  # validates :pic, presence: true
  #validates :lang, presence: true

  validates_confirmation_of :password


  def saved_collections
    return self.collections.to_a
  end


  def saved_products
    return self.products.to_a
  end


  def public_chats
    return self.public_Chats
  end


  def private_chats
    return self.private_Chats
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name   # assuming the user model has a name
      user.gender = auth.gender
      user.pic = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|

      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
        user.gender = data['gender'] if user.gender.blank?
        user.username = data['name'] if user.username.blank?
        user.pic = session['devise.facebook_data']['info']['image']+'?type=large'
        user.birth = data['birthday']
      end
    end
  end

end