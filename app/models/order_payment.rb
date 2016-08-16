class OrderPayment
  include MongoidBase

  field :request_id     , type: String
  field :parent_transaction_id, type: String
  field :transaction_id , type: String
  field :transaction_type, type: String
  field :payment_method , type: String
  field :merchant_id    , type: String
  field :status         , type: Symbol, default: :scheduled
  field :amount_cny         , type: Float, default: 0.0
  field :amount_eur         , type: Float, default: 0.0
  field :origin_currency     , type: String

  belongs_to :order     , :inverse_of => :order_payments, touch: true
  belongs_to :user      , :inverse_of => :orders

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
    save
  end

  # this automatically update the amounts depending on what was the original amount
  def refresh_currency_amounts!
    if origin_currency == 'CNY'
      self.amount_eur = Currency.new(order_payment.amount_cny, 'CNY').to_euro
    elsif origin_currency == 'EUR'
      self.amount_cny = Currency.new(order_payment.amount_eur, 'EUR').to_cny
    end
    save
  end


end
