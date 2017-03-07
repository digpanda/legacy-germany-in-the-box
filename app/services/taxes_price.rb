# very small library to calculate the taxes
class TaxesPrice

 attr_reader :sku, :product

 def initialize(sku)
   @sku = sku
   @product = sku.product
 end

 def price
   if product.duty_category
     (base_price * (product.duty_category.tax_rate / 100)).to_f
   else
     0.0
   end
 end

 def base_price
   sku.purchase_price # sku.price <-- in border guru calculation
 end

end
