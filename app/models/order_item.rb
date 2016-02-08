class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :quantity,  type: Integer
  field :weight,    type: Float
  field :price,     type: BigDecimal

  belongs_to :product,  :inverse_of => :order_items
  belongs_to :order,    :inverse_of => :order_items, touch: true
end