class ChangePriceIntoCasualPriceOnSkuPricing < Mongoid::Migration
  def self.up
    PackageSet.all.map(&:package_skus).flatten.each do |entry|
      entry.casual_price = entry.attributes['price']
      entry.save(validate: false)
      puts "PackageSku #{entry.id} updated with converted casual price"
    end

    Product.all.map(&:skus).flatten.each do |entry|
      entry.casual_price = entry.attributes['price']
      entry.save(validate: false)
      puts "Sku #{entry.id} updated with converted casual price"
    end
  end

  def self.down
  end
end
