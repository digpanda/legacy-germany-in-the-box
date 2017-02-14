class PaymentGatewayConversion < Mongoid::Migration
  def self.up

    # i don't trust mongoid so i do loops like a bad dev - Laurent
    Shop.all.each do |shop|
      # if shop.wirecard_ee_maid_cc && shop.wirecard_ee_secret_cc
      #   PaymentGateway.create({
      #     :shop_id => shop.id,
      #     :payment_method => :creditcard,
      #     :provider => :wirecard,
      #     :merchant_id => shop.wirecard_ee_maid_cc,
      #     :merchant_secret => shop.wirecard_ee_secret_cc
      #     })
      # end
    end

  end

  def self.down
  end
end
