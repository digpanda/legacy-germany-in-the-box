class Address
  include Mongoid::Document

  field :street,  type: String
  field :city,    type: String
  field :province,type: String
  field :zip,     type: String
  field :country, type: String

  belongs_to :user
end