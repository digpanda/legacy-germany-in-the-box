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
  scope :bought,      ->  { self.in( :status => [:paid, :custom_checkable, :custom_checking, :shipped] ) }
  scope :bought_or_unverified,      ->  { self.in( :status => [:payment_unverified, :paid, :custom_checkable, :custom_checking, :shipped] ) }

  # :new -> didn't try to pay
  # :paying -> is inside the process of payment
  # :payment_unverified -> we couldn't verify the payment (contact admin)
  # :payment_failed -> the payment failed (make another try when we got the functionality)
  # :paid -> it was paid
  # :custom_checkable -> the order has been handled by the shopkeeper (TODO: make the new system for it)
  # :custom_checking -> the order is being checked by the customs
  # :shipped -> the shopkepper has sent the package
  validates :status, presence: true , inclusion: {in: [:new, :paying, :payment_unverified, :payment_failed, :paid, :custom_checkable, :custom_checking, :shipped]}

  summarizes sku_list: :order_items, by: :quantity

  index({user: 1},  {unique: false,   name: :idx_order_user,   sparse: true})

  after_save :make_bill_id, :update_paid_at

  # refresh order status from payment
  # if the order is still not send / paid, it checks
  # if there's any change from the payment model
  def refresh_status_from!(order_payment)
    unless is_bought?
      if order_payment.status == :success
        self.status = :paid
      elsif order_payment.status == :unverified
        self.status = :payment_unverified
      elsif order_payment.status == :failed
        self.status = :payment_failed
      end
      self.save!
    end
  end

  # we considered as bought any status after paid
  def is_bought?
    [:paid, :custom_checkable, :custom_checking, :shipped].include?(status)
  end

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
