class VariantOption
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,  type: string

  embedded_in :variant, inverse_of: :options

  embeds_many :skus, inverse_of: :option

  validates :name,  presence: true
end
