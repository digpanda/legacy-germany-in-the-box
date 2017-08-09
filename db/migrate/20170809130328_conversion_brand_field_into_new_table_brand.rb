class ConversionBrandFieldIntoNewTableBrand < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      old_brand = product.attributes["brand"]
      puts "Old brand field is `#{old_brand}`"
      if Brand.where(name: old_brand["de"]).count == 0
        puts 'New brand was not already saved, let\'s make a new one.'
        new_brand = Brand.new
        new_brand.name_translations = old_brand
        new_brand.save!
        product.brand = new_brand
        product.save!
        puts 'It was saved.'
      else
        puts 'The brand was already registered.'
      end
    end
  end

  def self.down
  end
end
