class ResellerPriceMigrationAgain < Mongoid::Migration
  def self.up
    PackageSet.all.each do |package_set|
      package_set.package_skus.each do |package_sku|
        puts "PackageSku #{package_sku.id} update reseller price to `#{package_sku.price}`"
        package_sku.reseller_price = package_sku.price
        package_sku.save!(validate: false)
        package_set.save!(validate: false)
      end
    end
  end

  def self.down
  end
end
