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

  validates :email,         presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :name,          presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :register,      presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :desc,          presence: true,   length: {maximum: Rails.configuration.max_medium_text_length}
  validates :philosophy,    presence: true,   length: {maximum: Rails.configuration.max_medium_text_length}
  validates :stories,       presence: true,   length: {maximum: Rails.configuration.max_long_text_length}
end