class Brand
  include MongoidBase

  strip_attributes

  field :name, type: String, localize: true
  field :html_desc, type: String, localize: true
  field :position, type: Integer, default: 0

  has_many :products, inverse_of: :brand

end
