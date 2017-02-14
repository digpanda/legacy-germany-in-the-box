class OrderTaxAndDutyCost < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      # order.taxes_cost = order.tax_and_duty_cost
      # order.save
    end
  end

  def self.down
  end
end
