class ForceMerchantIdGeneration < Mongoid::Migration
  def self.up

    Shop.all.to_a.each do |s|
      s.force_merchant_id
      s.save!
    end

  end

  def self.down
  end
end