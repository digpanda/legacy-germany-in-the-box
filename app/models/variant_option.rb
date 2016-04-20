class VariantOption
  include MongoidBase

  strip_attributes

  field :name,          type: String,   localize: true

  embeds_many :suboptions, class_name: 'VariantOption', inverse_of: :parent

  embedded_in :parent,    inverse_of: :suboptions,   class_name: 'VariantOption'
  embedded_in :product,   inverse_of: :options

  accepts_nested_attributes_for :suboptions

  validates :name,      presence: true, length: {maximum: Rails.configuration.max_tiny_text_length}
end
