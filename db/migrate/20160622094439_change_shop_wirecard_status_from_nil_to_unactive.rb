class ChangeShopWirecardStatusFromNilToUnactive < Mongoid::Migration
  def self.up

    Shop.all.each do |shop|

      # WIRECARD RELATED : was removed for consistency

    end

  end

  def self.down
  end
end
