class ReferrerProvision
  include MongoidBase

  strip_attributes

  belongs_to :referrer, :class_name => "User", :inverse_of => :referrer_provisions
  belongs_to :order
  field :provision, type: Float

end
