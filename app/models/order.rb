class Order
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  belongs_to :customer
  has_many :order_items

  def total
    order_items.inject(0) { |sum, i| i.quantity * i.product.price }
  end
end