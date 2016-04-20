class Order
  include MongoidBase

  field :status, type: Symbol, default: :new

  belongs_to :user,                 :inverse_of => :orders
  belongs_to :delivery_destination, :inverse_of => :orders, :class_name => 'Address'

  has_many :order_items,  :inverse_of => :order, dependent: :restrict

  validates :status,                  presence: true, inclusion: {in: [:new, :checked_out, :shipped]}
  validates :user,                    presence: true, :unless => lambda { :new == self.status }
  validates :delivery_destination,    presence: true, :unless => lambda { :new == self.status }

  before_save :ensure_at_least_one_order_item, :unless => lambda { :new == self.status }

  def total_price
    order_items.inject(0) { |sum, i| sum += i.quantity * (:status != :new ? i.price : i.sku.price) }
  end

  def total_amount
    order_items.inject(0) { |sum, i| sum += i.quantity }
  end

  private

  def ensure_at_least_one_order_item
    order_items.count > 0
  end
end