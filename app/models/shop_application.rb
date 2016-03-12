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

  validates :email,         presence: true
  validates :name,          presence: true
  validates :founding_year, presence: true
  validates :register,      presence: true
  validates :desc,          presence: true,   length: {maximum: 1024*16}
  validates :philosophy,    presence: true,   length: {maximum: 1024*16}
  validates :stories,       presence: true,   length: {maximum: 1024*16}
end