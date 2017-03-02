# prepare an order to be transmitted to the Alipay server
class AlipayCheckout < BaseService

  include Rails.application.routes.url_helpers

  attr_reader :user, :order, :payment_gateway

  def initialize(user, order, payment_gateway)
    @user  = user
    @order = order
    @payment_gateway = payment_gateway
  end

  # we access the Wirecard::Hpp library and generate the needed datas
  # make a new OrderPayment linked to the request which we will manipulate later on
  def checkout_url!
    prepare_order_payment!
    url
  end

  private

  def raw_url
    @url ||= begin
      Alipay::Service.create_direct_pay_by_user_url(
        out_trade_no: "#{order.id}",
        subject: "Order #{order.id}",
        total_fee: "#{order.end_price.in_euro.to_yuan.display_raw}",
        return_url: processing_customer_checkout_url,
        notify_url: api_webhook_alipay_customer_url,
      )
    end
  end

  def url
    if Rails.env.production?
      raw_url
    else
      url.gsub("https://mapi.alipay.com/gateway.do?", "https://openapi.alipaydev.com/gateway.do?")
    end
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
      :order_id         => order.id,
      :status           => :scheduled,
      :user_id          => user.id
    }).first
  end

  def prepare_order_payment!
    matching_order_payment.tap do |order_payment|
      order_payment.merchant_id      = merchant_credentials[:merchant_id]
      # TODO TO CHANGE
      #order_payment.request_id       = hpp.request_id
      order_payment.user_id          = user.id
      order_payment.order_id         = order.id
      order_payment.status           = :scheduled
      order_payment.payment_method   = :alipay
      order_payment.transaction_type = :debit # TODO : make it dynamic ?
      order_payment.save
      order_payment.save_origin_amount!(order.end_price.in_euro.to_yuan.amount, "CNY")
      order_payment.refresh_currency_amounts!
    end
  end

end
