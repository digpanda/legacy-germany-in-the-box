class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include Genderize

  strip_attributes

  field :username,  type: String
  field :role,      type: Symbol, default: :customer
  field :fname,     type: String
  field :lname,     type: String
  field :birth,     type: String
  field :about,     type: String
  field :website,   type: String
  field :country,   type: String
  field :lang,      type: String
  field :provider,  type: String
  field :tel,       type: String
  field :mobile,    type: String

  has_and_belongs_to_many :followers,         :class_name => 'User',        :inverse_of => :following
  has_and_belongs_to_many :following,         :class_name => 'User',        :inverse_of => :followers
  has_and_belongs_to_many :liked_collections, :class_name => 'Collection',  :inverse_of => :users

  has_many :oCollections, class_name: 'Collection', :inverse_of => :user
  has_many :orders,                                 :inverse_of => :user
  has_many :addresses,                              :inverse_of => :user

  has_one  :shop, :inverse_of => :shopkeeper

  genderize (:gender)
  mount_uploader :pic, AttachmentUploader

  validates :role,      presence: true, inclusion: {in: [:customer, :shopkeeper, :admin]}
  validates :username,  presence: true
  validates :email,     presence: true, uniqueness: true
  validates :birth,     presence: true, :if => lambda { :customer == self.role }
  validates :gender,    presence: true, :if => lambda { :customer == self.role }

  validates :addresses, :length => { :maximum => Rails.configuration.max_num_addresses }, :if => lambda { :customer == self.role }

  validates_confirmation_of :password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,               type: String, default: ''
  field :encrypted_password,  type: String, default: ''

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

  acts_as_token_authenticatable

  field :authentication_token

  index({email: 1},               {unique: true,  name: :idx_user_email})
  index({followers: 1},           {unique: false, name: :idx_user_followers,          sparse: true})
  index({following: 1},           {unique: false, name: :idx_user_following,          sparse: true})
  index({liked_collections: 1},   {unique: false, name: :idx_user_liked_collections,  sparse: true})
end