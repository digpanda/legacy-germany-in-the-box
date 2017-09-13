class ConvertingOrderIntoMarketing < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      puts "Order convertible ? TIME : #{(order.c_at > 3.months.ago)}, STATUS : #{order.status}"
      if (order.c_at > 3.months.ago) && (order.status == :paid)
        puts "Order `#{order.id}` was created on #{order.c_at} and has the status `#{order.status}` will be converted."
        order.marketing = true
        order.save(validate: false)
      end
    end
    puts "End of process."
  end

  def self.down
  end
end
