class Order
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :status, type: Symbol, default: :new #[ :new, :accepted, :payed, :shipped ]

  belongs_to :user
  has_many :order_items

  def total
    order_items.inject(0) { |sum, i| i.quantity * i.product.price }
  end
end