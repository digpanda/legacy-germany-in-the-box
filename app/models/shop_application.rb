class ShopApplication

  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :email,           type: String
  field :name,            type: String
  field :desc,            type: String
  field :philosophy,      type: String
  field :stories,         type: String
  field :founding_year,   type: String
  field :register,        type: String

  validates :email,         presence: true,   length: {maximum: 64}
  validates :name,          presence: true,   length: {maximum: 128}
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :register,      presence: true,   length: {maximum: 32}
  validates :desc,          presence: true,   length: {maximum: 1024*16}
  validates :philosophy,    presence: true,   length: {maximum: 1024*16}
  validates :stories,       presence: true,   length: {maximum: 1024*16}
end