class PaymentGatewaysSeed < Mongoid::Migration
  def self.up

    Shop.all.each do |shop|
      [:alipay, :wechatpay].each do |payment_method|
        payment_gateway = PaymentGateway.where(shop_id: shop.id, payment_method: payment_method).first || PaymentGateway.new
        payment_gateway.shop_id = shop.id
        payment_gateway.provider = payment_method
        payment_gateway.payment_method = payment_method
        payment_gateway.merchant_id = nil
        payment_gateway.merchant_secret = nil
        payment_gateway.save
      end
    end

  end

  def self.down
  end
end
