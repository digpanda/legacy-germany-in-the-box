# prepare an order to be transmitted to the WireCard server
# those data will be used for the checkout process and, for instance UnionPay.
class WirecardCheckout < BaseService

  CONFIG_HPP = Rails.configuration.wirecard[:hpp]
  CONFIG_DEMO = Rails.configuration.wirecard[:demo]

  # :merchant_id => cart.submerchant_id <- original
  # :secret_key  => order.shop.wirecard_ee_secret_cc <- original

  attr_reader :user, :order

  def initialize(user, order)
    @user  = user
    @order = order
  end

  # we access the Wirecard::Hpp library and generate the needed datas
  # make a new OrderPayment linked to the request which we will manipulate later on
  def checkout!
    prepare_order_payment!
    hpp
  end

  private

  # always access the credentials throughout this class via this method
  # it changes depending on the environment and
  # has consequences on the database itself
  # on staging we will simply use the demo datas
  def merchant_credentials

    # TODO: make a new page to manage that
    payment_method = :creditcard

    # staging have real database datas
    # but we need to match with the demo mode
    # so it's a special case
    if Rails.env.staging?
      {
        :merchant_id => CONFIG_DEMO[payment_method][:merchant_id],
        :secret_key => CONFIG_DEMO[payment_method][:merchant_secret],
        :payment_method => payment_method
      }
    # everything else including test / development / production can follow the normal way
    # seed of sample datas should result into demo credentials registered in development
    else
      payment_gateway = order.shop.payment_gateways.where(payment_method: payment_method).first
      {
        :merchant_id  => payment_gateway.merchant_id,
        :secret_key   => payment_gateway.merchant_secret,
        :payment_method => payment_method
      }
    end
  end

  def hpp
    @hpp ||= Wirecard::Hpp.new(user, order, merchant_credentials)
  end

  # we either match an exact equivalent order payment which means
  # we already tried to pay but failed at any point of the process
  # before the `:scheduled` status changed
  def matching_order_payment
    @matching_order_payment ||= (recovered_order_payment || OrderPayment.new)
  end

  # may return nil
  def recovered_order_payment
    OrderPayment.where({
      :merchant_id      => merchant_credentials[:merchant_id],
      :order_id         => order.id,
      :payment_method   => hpp.payment_method,
      :transaction_type => hpp.transaction_type,
      :status           => :scheduled,
      :user_id          => user.id
    }).first
  end

  def prepare_order_payment!
    matching_order_payment.tap do |order_payment|
      order_payment.merchant_id      = merchant_credentials[:merchant_id]
      order_payment.request_id       = hpp.request_id
      order_payment.user_id          = user.id # shouldn't be duplicated, but mongoid added it automatically ...
      order_payment.order_id         = order.id
      order_payment.status           = :scheduled
      order_payment.payment_method   = hpp.payment_method
      order_payment.transaction_type = hpp.transaction_type
      order_payment.save
      # conversion is done on the fly while creating the payment
      # we store it because it change over time.
      # best would be to update it automatically when the order is paid
      # we dynamically set the amount via API response and set the other one via currency exchange
      order_payment.save_origin_amount!(hpp.amount, hpp.currency)
      order_payment.refresh_currency_amounts!
    end
  end

end
