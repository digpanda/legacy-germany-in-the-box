class CopyBrandIntoRawBrand < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      puts "Converting product brand `#{product.id}` ..."
      product.raw_brand_translations = product.brand_translations
      product.save!(validate: false)
      puts "Done."
    end
  end

  def self.down
  end
end
