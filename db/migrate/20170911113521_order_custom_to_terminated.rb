class OrderCustomToTerminated < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      if order.status == :custom_checking || order.status == :custom_checkable || order.status == :shipped
        order.status = :terminated
        order.save!(validate: false)
      end
    end
  end

  def self.down
  end
end
