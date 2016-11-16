require 'will_paginate/array'

class User
  include MongoidBase

  include Genderize

  strip_attributes

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

  field :username,  type: String
  field :role,      type: Symbol, default: :customer
  field :fname,     type: String
  field :lname,     type: String
  field :birth,     type: String
  field :city,      type: String
  field :province,  type: String
  field :country,   type: String
  field :about,     type: String
  field :website,   type: String
  field :tel,       type: String
  field :mobile,    type: String
  field :status,    type: Boolean, default: true
  field :provider,  type: String
  field :uid,       type: String

  field :wechat_unionid, type: String
  field :wechat_openid,  type: String

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_and_belongs_to_many :favorites, :class_name => 'Product'

  has_and_belongs_to_many :liked_collections, :class_name => 'Collection',  :inverse_of => :users

  scope :without_detail, -> { only(:_id, :pic, :country, :username) }

  has_one  :dCollection,  class_name: 'Collection', :inverse_of => :user

  has_many :oCollections, class_name: 'Collection', :inverse_of => :user
  has_many :orders,                                 :inverse_of => :user,   :dependent => :restrict
  has_many :addresses,                              :inverse_of => :user
  has_many :notifications
  has_many :notes,                                  :inverse_of => :user,   :dependent => :restrict

  has_one  :shop,         :inverse_of => :shopkeeper,   :dependent => :restrict

  genderize (:gender)
  mount_uploader :pic, LogoImageUploader

  validates :role,          presence: true, inclusion: {in: [:customer, :shopkeeper, :admin]}
  validates :email,         presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :status,        presence: true

  validates :fname,         presence: true, :if => lambda { :customer == self.role }, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :lname,         presence: true, :if => lambda { :customer == self.role }, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :about,         length: {maximum: Rails.configuration.max_medium_text_length}
  validates :website,       length: {maximum: Rails.configuration.max_short_text_length}

  validates :oCollections, :length => { :maximum => Rails.configuration.max_customer_collections },   :if => lambda { :customer   == self.role }
  validates :oCollections, :length => { :maximum => Rails.configuration.max_shopkeeper_collections }, :if => lambda { :shopkeeper == self.role }

  validates :addresses,    :length => { :maximum => Rails.configuration.max_num_addresses }, :if => lambda { :customer == self.role }

  validates_confirmation_of :password

  acts_as_token_authenticatable

  field :authentication_token

  index({email: 1},               {unique: true,  name: :idx_user_email})
  index({followers: 1},           {unique: false, name: :idx_user_followers,          sparse: true})
  index({following: 1},           {unique: false, name: :idx_user_following,          sparse: true})
  index({liked_collections: 1},   {unique: false, name: :idx_user_liked_collections,  sparse: true})

  before_destroy :destroy_has_shop, :destroy_has_orders
  def destroy_has_shop
    if self.shop
      errors.add :base, "Cannot delete user with a shop"
      false
    else
      true
    end
  end

  def destroy_has_orders
    if self.orders.count > 0
      errors.add :base, "Cannot delete user with orders"
      false
    else
      true
    end
  end

  def admin?
    self.role == :admin
  end

  def shopkeeper?
    self.role == :shopkeeper
  end

  def customer?
    self.role == :customer
  end
  
  def destroyable?
    !self.decorate.admin?
  end

  def wechat?
    self.provider == "wechat"
  end

  def check_valid_password?(params)
    if self.valid_password?(params[:user][:current_password])
      true
    else
      self.errors.add(:password, "wrong")
      false
    end
  end

  def valid_email?
    !self.email.include?("@wechat.com")
  end

  def password_required?
    super && provider.blank?
  end

end
