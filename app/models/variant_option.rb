class VariantOption
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,          type: String
  field :name_locales,  type: Hash

  embeds_many :suboptions, class_name: 'VariantOption', inverse_of: :parent

  embedded_in :parent,    inverse_of: :suboptions,   class_name: 'VariantOption'
  embedded_in :product,   inverse_of: :options

  accepts_nested_attributes_for :suboptions

  validates :name,      presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
end
