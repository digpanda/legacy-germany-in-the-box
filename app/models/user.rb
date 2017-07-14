require 'will_paginate/array'

class User
  include MongoidBase
  include Mongoid::Search
  include Genderize

  strip_attributes

  # research system
  search_in :id, :email, :role, :last_sign_in_at

  ## Database authenticatable
  field :email,               type: String, default: ''
  field :encrypted_password,  type: String, default: ''
  field :precreated, type: Boolean, default: false

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

  field :nickname,  type: String
  field :role,      type: Symbol, default: :customer
  field :fname,     type: String
  field :lname,     type: String
  field :birth,     type: String
  field :city,      type: String
  field :province,  type: String
  field :country,   type: String
  field :about,     type: String
  field :website,   type: String
  field :mobile,    type: String
  field :status,    type: Boolean, default: true
  field :provider,  type: String
  field :uid,       type: String

  # referrer as someone lead is binded with him
  belongs_to :parent_referrer, :inverse_of => :child_user, :class_name => 'Referrer'
  field :parent_referred_at, type: Time
  # referrer as a model considering the user is a referrer
  has_one :referrer, :inverse_of => :user, dependent: :destroy
  accepts_nested_attributes_for :referrer

  field :wechat_unionid, type: String
  field :wechat_openid,  type: String

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_and_belongs_to_many :favorites, :class_name => 'Product'

  scope :without_detail, -> { only(:_id, :pic, :country, :username) }

  has_many :orders,                                 :inverse_of => :user,   :dependent => :restrict
  embeds_many :addresses,                              :inverse_of => :user
  has_many :notifications
  has_many :notes,                                  :inverse_of => :user,   :dependent => :restrict

  has_one  :shop,         :inverse_of => :shopkeeper,   :dependent => :restrict
  has_one  :cart

  genderize (:gender)
  mount_uploader :pic, AvatarUploader

  validates :role,          presence: true, inclusion: {in: [:customer, :shopkeeper, :admin]}
  validates :email,         presence: true, length: {maximum: Rails.configuration.gitb[:max_tiny_text_length]}
  validates :status,        presence: true

  # TODO : we deactivated this protection because wechat don't return it
  # but we need to create the customer anyway.
  # we should add a system to force people to add those important information before they buy if we don't have it.
  # NOTE : we could actually refactor it with the short email forcing we did before, but in another controller to stay clean. (`ensure user information blbalbla`)

  # validates :fname,         presence: true, :if => lambda { :customer == self.role }, length: {maximum: Rails.configuration.gitb[:max_tiny_text_length]}
  # validates :lname,         presence: true, :if => lambda { :customer == self.role }, length: {maximum: Rails.configuration.gitb[:max_tiny_text_length]}
  #
  validates :about,         length: {maximum: Rails.configuration.gitb[:max_medium_text_length]}
  validates :website,       length: {maximum: Rails.configuration.gitb[:max_short_text_length]}
  validates_confirmation_of :password

  acts_as_token_authenticatable

  field :authentication_token

  scope :admins, -> { where(role: :admin) }

  before_save :ensure_valid_mobile

  def ensure_valid_mobile
    if mobile
      mobile.gsub!(/[[:space:]]/, '')
    end
  end

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

  def self.emails_list
    self.all.reduce([]) { |acc, user| acc << user.email }
  end

  def primary_address
    addresses.where(primary: true).first || addresses.first
  end

  # this was made to get only the appropriate orders
  # of the customer to get back to the cart
  def cart_orders
    orders.unpaid.order_by(:u_at => :desc)
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

  def notifications?
    self.notifications.unreads.count > 0
  end

  def wechat?
    self.provider == "wechat"
  end

  def valid_for_checkout?
    valid_email? && fname && lname
  end

  def valid_email?
    !email.include?("@wechat.com")
  end

  def referrer?
    self.referrer.present?
  end

  # if there's any missing info the user
  # will be redirected on log-in
  def missing_info?
    if self.referrer?
        return true if self.mobile.blank?
        return true if self.referrer.agb == false
    end
    false
  end

  def password_required?
    super && provider.blank?
  end

  def new_notifications?
    notifications.unreads.count > 0
  end

  def short_union_id
    self&.wechat_unionid&.split(//)&.last(3)&.join.to_s
  end

end
