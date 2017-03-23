class Cart
  include MongoidBase

  has_many :orders
  belongs_to :user

end
