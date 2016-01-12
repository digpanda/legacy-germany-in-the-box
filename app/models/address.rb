class Address
  include Mongoid::Document

  field :street_building_room,  type: String
  field :district,              type: String
  field :city,                  type: String
  field :province,              type: String

  field :zip,                   type: String
  field :country,               type: String

  field :primary,               type: Boolean

  belongs_to :user

  has_many :orders

  validates :street_building_room,  presence: true
  validates :city,                  presence: true
  validates :zip,                   presence: true
  validates :country,               presence: true
end