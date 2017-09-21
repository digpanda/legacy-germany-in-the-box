class ChangePToRBillsOrders < Mongoid::Migration
  def self.up
    Order.skip_callback(:save, :after, :make_bill_id)
    Order.where({:bill_id.ne => nil}).each do |order|
      puts "Old format bill id : #{order.bill_id}"
      order.bill_id = order.bill_id.gsub("P", "R")
      order.save(validate: false)
      puts "New format bill id : #{order.bill_id}"
    end
    Order.set_callback(:save, :after, :make_bill_id)
  end

  def self.down
  end
end
