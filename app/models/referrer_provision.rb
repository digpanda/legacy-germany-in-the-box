class ReferrerProvision
  include MongoidBase

  strip_attributes

  belongs_to :referrer, :class_name => "Referrer", :inverse_of => :provisions
  belongs_to :order
  field :provision, type: Float

end
