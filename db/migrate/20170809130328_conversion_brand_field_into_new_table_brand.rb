class ConversionBrandFieldIntoNewTableBrand < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      old_brand = product.attributes["brand"]
      puts "Old brand field is `#{old_brand}`"
      brand = Brand.where(name: old_brand["de"]).first

      unless brand
        puts 'New brand was not already saved, let\'s make a new one.'
        brand = Brand.new
        brand.name_translations = old_brand
        brand.save!
        puts "It was saved (#{brand.id})."
      else
        puts "The brand was already registered (#{brand.id})."
      end

      product.brand = brand
      product.save!
    end
  end

  def self.down
  end
end
