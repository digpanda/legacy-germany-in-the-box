class Order
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :status, type: Symbol, default: :new #[ :new, :checked_out, :shipped ]

  belongs_to :user

  belongs_to :delivery_destination, class_name: 'Address'

  has_many :order_items

  def total_price
    order_items.inject(0) { |sum, i| sum += i.quantity * i.product.price }
  end

  def total_amount
    order_items.inject(0) { |sum, i| sum += i.quantity }
  end
end