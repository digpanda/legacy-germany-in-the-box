class ReferrerProvisionOperation
  include MongoidBase

  strip_attributes

  field :amount, type: Float, default: 0
  field :desc, type: String

  belongs_to :referrer

  validates :amount, numericality: { other_than: 0 }
end
