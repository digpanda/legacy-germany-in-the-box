class ChangeBillFormat < Mongoid::Migration
  def self.up
    Order.skip_callback(:save, :after, :make_bill_id)
    Order.where({:bill_id.ne => nil}).each do |order|
      puts "Old format bill id : #{order.bill_id}"
      start_day = order.c_at.beginning_of_day
      digits = start_day.strftime("%Y%m%d")
      num = Order.where({:bill_id.ne => nil}).where({:c_at.gte => start_day}).count + 1
      order.bill_id = "P#{digits}-#{num}"
      order.save
      puts "New format bill id : #{order.bill_id}"
    end
    Order.set_callback(:save, :after, :make_bill_id)
  end

  def self.down
  end
end
