class Sku
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :code,      type: String
  field :price,     type: BigDecimal
  field :currency,  type: String,     default: '€'
  field :quantity,  type: Integer
  field :limited,   type: Boolean,    default: false

  embedded_in :option,  class: 'VariantOption',  inverse_of: :skus
  
  validates :code,      presence: true
  validates :price,     presence: true
  validates :currency,  presence: true, inclusion: {in: ['€']}
  validates :quantity,  presence: true, :numericality => { :greater_than_or_equal_to => 0 }, :if => lambda { self.limited }
  validates :limited,   presence: true
end
