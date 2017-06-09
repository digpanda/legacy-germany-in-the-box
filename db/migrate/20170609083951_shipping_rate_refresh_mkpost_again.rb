class ShippingRateRefreshMkpostAgain < Mongoid::Migration
  def self.up
    Tasks::Digpanda::RefreshShippingRates.new
  end

  def self.down
  end
end
