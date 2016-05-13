class Order
  include MongoidBase
  include HasProductSummaries

  field :status, type: Symbol, default: :new
  field :desc,   type: String

  field :border_guru_quote_id, type: String

  belongs_to :user,                 :inverse_of => :orders

  embeds_one :delivery_destination,  :inverse_of => :orders, :class_name => 'Address'
  embeds_one :delivery_destination,  :inverse_of => :orders, :class_name => 'Address'

  has_many :order_items,      :inverse_of => :order,    dependent: :restrict
  has_many :order_payments,   :inverse_of => :order,    dependent: :restrict

  # TODO : inclusion should be re-abilited when we are sure of what we include
  validates :status,                  presence: true #, inclusion: {in: [:new, :checked_out, :shipped, :paying,]}
  validates :user,                    presence: true, :unless => lambda { :new == self.status }
  validates :delivery_destination,    presence: true, :unless => lambda { :new == self.status }

  before_save :ensure_at_least_one_order_item, :unless => lambda { :new == self.status }

  summarizes sku_list: :order_items, by: :quantity


  field :border_guru_quote_id, type: String
  field :shipping_cost, type: Float
  field :tax_and_duty_cost, type: Float
  field :border_guru_shipment_id, type: String
  field :border_guru_link_tracking, type: String
  field :border_guru_link_payment, type: String


  def total_price
    order_items.inject(0) { |sum, i| sum += i.quantity * (:status != :new ? i.price : i.sku.price) }
  end

  def total_amount
    order_items.inject(0) { |sum, i| sum += i.quantity }
  end

  def update_for_checkout!(user, delivery_destination_id)

    self.update({

      :status               => :paying,
      :user                 => user,
      :delivery_destination => user.addresses.find(delivery_destination_id).attributes,
    
    })

    self

  end

  private

  def ensure_at_least_one_order_item
    order_items.size > 0
  end
end