# prepare an order to be transmitted to the WireCard server
# those data will be used for the checkout process and, for instance UnionPay.
class WirecardCheckout < BaseService

  CONFIG_HPP = Rails.configuration.wirecard[:hpp]

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

  # /!\ WARNING
  # always access the credentials throughout this class via this method
  # it changes depending on the environment and
  # has consequences on the database itself
  def merchant_credentials
    if Rails.env.production?
      {
        :merchant_id  => order.shop.wircard_ee_maid_cc,
        :secret_key   => order.shop.wirecard_ee_secret_cc,
        # :payment_method => :creditcard # we can force a payment method here
      }
    else
      {
        :merchant_id  => CONFIG_HPP[:demo][:merchant_id],
        :secret_key   => CONFIG_HPP[:demo][:secret_key],
        # :payment_method => :upop # we can force a payment method here
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
    @matching_order_payment ||= OrderPayment.where({
      :merchant_id      => merchant_credentials[:merchant_id],
      :order_id         => order.id,
      :payment_method   => hpp.payment_method,
      :transaction_type => hpp.transaction_type,
      :status           => :scheduled,
      :user_id          => user.id
    }).first || OrderPayment.new
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
