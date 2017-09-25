class OrderPayment
  include MongoidBase
  include Mongoid::Search

  # research system
  search_in :id, :request_id, :transaction_id, :amount_cny, :status, :amount_eur, :payment_method, :c_at, shop: :shopname, order: :id

  field :request_id     , type: String
  field :parent_transaction_id, type: String
  field :transaction_id , type: String
  field :transaction_type, type: String
  field :payment_method , type: Symbol
  field :merchant_id    , type: String
  field :status         , type: Symbol, default: :scheduled # [:scheduled, :unverified, :success, :failed]
  field :amount_cny         , type: Float, default: 0.0
  field :amount_eur         , type: Float, default: 0.0
  field :origin_currency     , type: String

  belongs_to :order     , inverse_of: :order_payments, touch: true
  belongs_to :user      , inverse_of: :orders

  def shop
    order.shop
  end

  # this save into the correct field depending the currency
  def save_origin_amount!(amount, currency)
    if currency == 'CNY'
      self.amount_cny = amount
    elsif currency == 'EUR'
      self.amount_eur = amount
    end
    self.origin_currency = currency
    save
  end

  # this automatically update the amounts depending on what was the original amount
  def refresh_currency_amounts!
    if origin_currency == 'CNY'
      self.amount_eur = Currency.new(amount_cny, 'CNY').to_euro.amount
    elsif origin_currency == 'EUR'
      self.amount_cny = Currency.new(amount_eur, 'EUR').to_cny.amount
    end
    save
  end

  def refund?
    transaction_type == 'refund-purchase' || transaction_type == 'refund-debit'
  end

  def refundable?
    return false if self.refund?
    self.order.decorate.total_paid != 0
  end

  def scheduled?
    status == :scheduled
  end

  def unverified?
    status == :unverified
  end
end
