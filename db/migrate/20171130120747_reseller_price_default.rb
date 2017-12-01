class ResellerPriceDefault < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      product.skus.each do |sku|
        puts "Sku #{sku.id} update reseller price to `#{sku.price}`"
        sku.reseller_price = sku.price
        sku.save(validate: false)
        product.save(validate: false)
      end
    end
  end

  def self.down
  end
end
