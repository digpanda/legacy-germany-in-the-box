# very small library to calculate the taxes
class TaxesPrice

 attr_reader :sku, :product

 def initialize(sku)
   @sku = sku
   @product = sku.product
 end

 def price
   if product.duty_category
     (sku.price * (product.duty_category.tax_rate / 100)).to_f
   else
     0.0
   end
 end

end
