class ReferrerProvisionOperation
  include MongoidBase

  strip_attributes

  field :amount, type: Float, default: 0
  field :desc, type: String

  belongs_to :referrer

end
