class AddAchatMerchantId < Mongoid::Migration
  def self.up
    Shop.all.each(&:save!)
  end

  def self.down
  end
end