class ReferrerProvision
  include MongoidBase

  strip_attributes

  field :provision, type: Float

  belongs_to :referrer, class_name: "Referrer", inverse_of: :provisions
  belongs_to :order

end
