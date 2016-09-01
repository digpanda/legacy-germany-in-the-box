class CanceledToCancelledOrders < Mongoid::Migration
  def self.up

    Order.where(status: :canceled).each do |order|
      order.status = :cancelled
      order.save
    end

  end

  def self.down
  end
end
