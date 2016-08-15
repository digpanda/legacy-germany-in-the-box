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
  field :hermes_pickup_email_sent_at,   type: Time
  field :bill_id, type: String
  field :paid_at, type: Time

  belongs_to :shop,                 :inverse_of => :orders
  belongs_to :user,                 :inverse_of => :orders

  belongs_to :shipping_address,        :class_name => 'Address'
  belongs_to :billing_address,         :class_name => 'Address'

  has_many :order_items,            :inverse_of => :order,    dependent: :restrict
  has_many :order_payments,         :inverse_of => :order,    dependent: :restrict

  scope :nonempty,    ->  {  where( :order_items_count.gt => 0 ) }
  scope :bought,      ->  { self.in( :status => [:paid, :custom_checking, :shipped] ) }

  validates :status,                  presence: true , inclusion: {in: [:new, :paying, :paid, :custom_checking, :shipped]}

  summarizes sku_list: :order_items, by: :quantity

  index({user: 1},  {unique: false,   name: :idx_order_user,   sparse: true})

  after_save :make_bill_id, :update_paid_at

  private

  def update_paid_at
    if paid_at.nil? && status == :paid
      self.paid_at = Time.now
      self.save
    end
  end

  def make_bill_id
    if bill_id.nil?
      year = c_at.strftime("%Y")
      num = Order.where(:bill_id.ne => nil).count + 1 # mongoid not able to count entry position, classical stuff.
      self.bill_id = "#{year}-P#{num}"
      self.save
    end
  end

end
