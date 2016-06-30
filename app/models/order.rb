class Order
  include MongoidBase
  include HasProductSummaries

  field :status,                    type: Symbol, default: :new
  field :desc,                      type: String
  field :border_guru_quote_id,      type: String
  field :shipping_cost,             type: Float
  field :tax_and_duty_cost,         type: Float
  field :border_guru_shipment_id,   type: String
  field :border_guru_link_tracking, type: String
  field :border_guru_link_payment,  type: String
  field :order_items_count,         type: Fixnum, default: 0
  field :minimum_sending_date,      type: Time

  belongs_to :shop,                 :inverse_of => :orders
  belongs_to :user,                 :inverse_of => :orders

  belongs_to :shipping_address,        :class_name => 'Address'
  belongs_to :billing_address,         :class_name => 'Address'

  has_many :order_items,            :inverse_of => :order,    dependent: :restrict
  has_many :order_payments,         :inverse_of => :order,    dependent: :restrict

  scope :nonempty,    ->  {  where( :order_items_count.gt => 0 ) }
  scope :bought,      ->  { self.in( :status => [:paid, :custom_checking, :shippable, :shipped] ) }


  # TODO : inclusion should be re-abilited when we are sure of what we include
  validates :status,                  presence: true #, inclusion: {in: [:new, :paying, :paid, :custom_checking, :shippable, :shipped]}
  #validates :user,                    presence: true, :unless => lambda { :new == self.status }
  #validates :shipping_address,        presence: true, :unless => lambda { :new == self.status }
  #validates :billing_address,         presence: true, :unless => lambda { :new == self.status }

  before_save :ensure_at_least_one_order_item, :unless => lambda { :new == self.status }

  summarizes sku_list: :order_items, by: :quantity

  index({user: 1},  {unique: false,   name: :idx_order_user,   sparse: true})

  def is_bought?
    not [:new, :paying].include?(self.status)
  end

  def total_price_in_yuan
    total_price * Settings.instance.exchange_rate_to_yuan
  end

  def shipping_cost_in_yuan
    (shipping_cost ? shipping_cost : 0) * Settings.instance.exchange_rate_to_yuan
  end

  def tax_and_duty_cost_in_yuan
    (tax_and_duty_cost ? tax_and_duty_cost : 0 ) * Settings.instance.exchange_rate_to_yuan
  end

  def reach_todays_limit?(new_price_increase, new_quantity_increase)
    if order_items.size == 0 && new_quantity_increase == 1
      false
    elsif order_items.size == 1 && new_quantity_increase == 0
      false
    else
      (self.total_price_in_yuan + new_price_increase) > Settings.instance.max_total_per_day
    end
  end

  def total_price
    if self.is_bought?
      order_items.inject(0) { |sum, i| sum += i.quantity * i.price }
    else
      order_items.inject(0) { |sum, i| sum += i.quantity * i.sku.price }
    end
  end

  def total_amount
    order_items.inject(0) { |sum, i| sum += i.quantity }
  end

  def update_for_checkout(user, delivery_destination_id, border_guru_quote_id, shipping_cost, tax_and_duty_cost)
    a = user.addresses.find(delivery_destination_id)

    self.update({
      :status               => :paying,
      :user                 => user,
      :shipping_address     => a,
      :billing_address      => a,
      :border_guru_quote_id => border_guru_quote_id,
      :shipping_cost        => shipping_cost,
      :tax_and_duty_cost    => tax_and_duty_cost
    })

    # Todo: perhaps we don't need to return self. What we need is the result of last update.
    #self
  end

  def processable?
    self.status == :paid && (Time.now.strftime("%k").to_i < 12 || Time.now.strftime("%k").to_i > 13)
  end

  def shippable?
    self.status == :custom_checking && Time.now > self.minimum_sending_date
  end

  private

  def ensure_at_least_one_order_item
    #order_items.size > 0
  end
end