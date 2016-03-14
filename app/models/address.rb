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
  field :function,              type: String

  field :primary,               type: Boolean, default: false

  belongs_to :user, :inverse_of => :addresses;
  belongs_to :shop, :inverse_of => :address;

  has_and_belongs_to_many :orders,  :inverse_of => :delivery_destination

  validates :street_building_room,  presence: true, length: {maximum: Rails.configuration.max_short_text_length}
  validates :district,              presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :city,                  presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :province,              presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :zip,                   presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :country,               presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}

  validates :primary,               presence: true
end