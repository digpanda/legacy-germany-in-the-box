class ChangeShopWirecardStatusFromNilToUnactive < Mongoid::Migration
  def self.up

    Shop.all.each do |shop|

      if shop.wirecard_status.nil?
        shop.wirecard_status = :unactive
        shop.wirecard_status
        shop.save!
        "Puts Shop #{shop.id} updated to `:unactive`"
      end

    end

  end

  def self.down
  end
end