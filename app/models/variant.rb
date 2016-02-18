class Variant
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,  type: String

  embedded_in :product, inverse_of: :variants

  embeds_many :options, class_name: 'VariantOption', inverse_of: :variant

  validates :name,  presence: true
end
