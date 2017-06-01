class PackageSetBasedShippingCost < Mongoid::Migration
  def self.up
    PackageSet.all.each do |package_set|
      puts "Processing PackageSet `#{package_set.id}` ..."
      package_set.shipping_cost = package_set.package_skus.reduce(0) do |acc, package_sku|
        if package_sku.shipping_per_unit
          acc + (package_sku.shipping_per_unit * package_sku.quantity)
        end
      end
      puts "New shipping cost is `#{package_set.shipping_cost}`"
      package_set.save(validation: false)
    end
  end

  def self.down
  end
end
