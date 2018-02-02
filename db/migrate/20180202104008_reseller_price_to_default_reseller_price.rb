class ResellerPriceToDefaultResellerPrice < Mongoid::Migration
  def self.up
    PackageSet.all.map(&:package_skus).flatten.each do |entry|
      entry.default_reseller_price = entry.attributes['reseller_price']
      entry.junior_reseller_price = entry.attributes['reseller_price']
      entry.senior_reseller_price = entry.attributes['reseller_price']
      entry.save(validate: false)
      puts "PackageSku #{entry.id} updated with new reseller prices"
    end

    Product.all.map(&:skus).flatten.each do |entry|
      entry.default_reseller_price = entry.attributes['reseller_price']
      entry.junior_reseller_price = entry.attributes['reseller_price']
      entry.senior_reseller_price = entry.attributes['reseller_price']
      entry.save(validate: false)
      puts "Sku #{entry.id} updated with new reseller prices"
    end

  end

  def self.down
  end
end
