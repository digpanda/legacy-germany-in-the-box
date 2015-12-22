class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :quantity, type: Integer
  field :weight, type: Float
  field :price, type: BigDecimal

  belongs_to :product

  belongs_to :order, touch: true
end