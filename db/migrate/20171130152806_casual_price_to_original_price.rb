class CasualPriceToOriginalPrice < Mongoid::Migration
  def self.up
    PackageSet.all.each do |package_set|
      puts "Setting original price for PackageSet #{package_set.id}"
      package_set.original_price = package_set.attributes['casual_price']
      package_set.save!(validate: false)
    end
  end

  def self.down
  end
end
