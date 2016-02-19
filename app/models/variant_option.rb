class VariantOption
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,          type: String
  field :name_locales,  type: Hash

  embedded_in :variant, inverse_of: :options

  validates :name,      presence: true
end
