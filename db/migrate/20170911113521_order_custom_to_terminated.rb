class OrderCustomToTerminated < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      puts "Processing #{order.id} ..."
      if [:custom_checking, :custom_checkable, :shipped].include? order.status
        puts "Changing #{order.id} status from `#{order.status}` to `#{terminated}`"
        order.status = :terminated
        order.save!(validate: false)
      end
    end
  end

  def self.down
  end
end
