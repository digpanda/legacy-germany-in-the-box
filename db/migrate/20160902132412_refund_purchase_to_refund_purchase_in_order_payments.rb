class RefundPurchaseToRefundPurchaseInOrderPayments < Mongoid::Migration
  def self.up
    OrderPayment.all.each do |order_payment|
      if order_payment.transaction_type == :refund_purchase
        order_payment.transaction_type = 'refund-purchase'
        order_payment.save
      end
    end
  end

  def self.down
  end
end
