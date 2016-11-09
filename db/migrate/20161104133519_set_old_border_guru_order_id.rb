class SetOldBorderGuruOrderId < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      if order.border_guru_order_id.nil?
        order.border_guru_order_id = "#{order.id}"
        order.save
      end
    end
  end

  def self.down
  end
end
