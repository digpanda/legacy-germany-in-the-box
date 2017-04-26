class FixingOrphanOrderPayments < Mongoid::Migration
  def self.up
    OrderPayment.all.each do |order_payment|
      unless order_payment.order
        order_payment.delete
      end
    end
  end

  def self.down
  end
end
