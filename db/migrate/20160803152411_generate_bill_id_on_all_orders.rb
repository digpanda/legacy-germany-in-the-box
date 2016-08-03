class GenerateBillIdOnAllOrders < Mongoid::Migration
  def self.up

    Order.all.each do |order|
      if order.bill_id.nil?
        year = order.c_at.strftime("%Y")
        num = Order.where(:bill_id.ne => nil).count + 1 # mongoid not able to count entry position, classical stuff.
        order.bill_id = "#{year}-P#{num}"
        order.save
      end
    end

  end

  def self.down
  end
end