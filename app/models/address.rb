class Address
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :street_building_room,  type: String
  field :district,              type: String
  field :city,                  type: String
  field :province,              type: String
  field :zip,                   type: String
  field :country,               type: String

  field :fname,                 type: String
  field :lname,                 type: String
  field :email,                 type: String
  field :mobile,                type: String
  field :tel,                   type: String

  field :primary,               type: Boolean, default: false

  belongs_to :user, :inverse_of => :addresses;

  has_and_belongs_to_many :orders,  :inverse_of => :delivery_destination

  validates :street_building_room,  presence: true
  validates :district,              presence: true
  validates :city,                  presence: true
  validates :province,              presence: true
  validates :zip,                   presence: true
  validates :country,               presence: true

  validates :primary,               presence: true

  validates :user,                  presence: true
end