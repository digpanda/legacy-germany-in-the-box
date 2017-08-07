class VariantOption
  include MongoidBase

  strip_attributes

  field :name,          type: String,   localize: true

  embeds_many :suboptions, class_name: 'VariantOption', inverse_of: :parent

  embedded_in :parent,    inverse_of: :suboptions,   class_name: 'VariantOption'
  embedded_in :product,   inverse_of: :options

  accepts_nested_attributes_for :suboptions

  validates :name,      presence: true, length: {maximum: Rails.configuration.gitb[:max_tiny_text_length]}

  # this was made while refactoring
  # it simply get the results by name and return an array with name and id
  # the naming was done fast. you can rename it.
  def self.names_array
    order_by(name: :asc).map do |suboption|
      [suboption.name, suboption.id.to_s]
    end
  end

end
