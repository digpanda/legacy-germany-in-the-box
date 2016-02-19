class VariantOption
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,      type: String

  embedded_in :variant, inverse_of: :options

  validates :name,      presence: true
end
