class AddAchatMerchantId < Mongoid::Migration
  def self.up
    Shop.all.to_a.each do |s|
      # puts s.gen_merchant_id
      # s.merchant_id = s.gen_merchant_id
      # s.save!
    end
  end

  def self.down
  end
end
