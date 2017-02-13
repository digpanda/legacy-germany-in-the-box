# very small library to calculate the taxes
class TaxesPrice

 attr_reader :sku, :product

 def initialize(sku)
   @sku = sku
   @product = sku.product
 end

 def price
   if product.duty_category
     sku.price * (product.duty_category.tax_rate / 100)
   else
     0
   end
 end


end
