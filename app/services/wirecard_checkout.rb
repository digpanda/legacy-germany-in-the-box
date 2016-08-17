# prepare an order to be transmitted to the WireCard server
# those data will be used for the checkout process and, for instance UnionPay.
class WirecardCheckout < BaseService

  DEBIT_TRANSACTION_TYPE = "debit"
  DEMO_UOP_MERCHANT_ID = 'dfc3a296-3faf-4a1d-a075-f72f1b67dd2a' # UNION PAY
  DEMO_UOP_WIRECARD_EE_SECRET_CC = '6cbfa34e-91a7-421a-8dde-069fc0f5e0b8' # UNION PAY

  # :merchant_id => cart.submerchant_id <- original
  # :secret_key  => order.shop.wirecard_ee_secret_cc <- original

  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  # we access the Wirecard::Hpp library and generate the needed datas
  # make a new OrderPayment linked to the request which we will manipulate later on
  def checkout!
    binding.pry
    prepare_order_payment!
    hpp
  end

  private

  def merchant_credentials
    if Rails.env.production?
      {
        :merchant_id  => order.shop.wirecard_ee_user_cc, # or maybe `merchant_id` ? TODO: check it out with Timo
        :secret_key   => order.shop.wirecard_ee_secret_cc,
      }
    else
      {
        :merchant_id  => DEMO_UOP_MERCHANT_ID,
        :secret_key   => DEMO_UOP_WIRECARD_EE_SECRET_CC,
      }
    end
  end

  def hpp
    @hpp ||= Wirecard::Hpp.new(user, order, merchant_credentials)
  end

  # TODO: instead of create a new order payment, we should recover the old one in case we do it many times
  def prepare_order_payment!
    OrderPayment.new.tap do |order_payment|
      order_payment.merchant_id    = merchant_credentials[:merchant_id]
      order_payment.request_id     = hpp.request_id
      order_payment.user_id        = user.id # shouldn't be duplicated, but mongoid added it automatically ...
      order_payment.order_id       = order.id
      order_payment.transaction_type = DEBIT_TRANSACTION_TYPE
      # conversion is done on the fly while creating the payment
      # we store it because it change over time.
      # best would be to update it automatically when the order is paid
      order_payment.payment_method = hpp.payment_method
      order_payment.save
      # we dynamically set the amount via API response and set the other one via currency exchange
      order_payment.save_origin_amount!(hpp.amount, hpp.currency)
      order_payment.refresh_currency_amounts!
    end
  end

end
