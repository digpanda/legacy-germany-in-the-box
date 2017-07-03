class ExchangeRateOnOrder < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      puts "Order exchange rate will be set to `#{Setting.instance.exchange_rate_to_yuan}` ..."
      order.exchange_rate = Setting.instance.exchange_rate_to_yuan
      order.save(validation: false) # we don't care about the rest
      puts "Done."
    end
  end

  def self.down
  end
end
