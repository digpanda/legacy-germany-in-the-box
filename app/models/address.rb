class Address
  include Mongoid::Document

  field :address1,  type: String
  field :address2,  type: String
  field :address3,  type: String
  field :address4,  type: String

  field :zip,       type: String
  field :country,   type: String

  belongs_to :user
end