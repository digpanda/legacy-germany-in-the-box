FactoryGirl.define do
  factory :package_sku do

    quantity 2
    casual_price { BigDecimal.new(rand(1..10)) }

    default_reseller_price { BigDecimal.new(rand(1..10)) }
    junior_reseller_price { BigDecimal.new(rand(1..10)) }
    senior_reseller_price { BigDecimal.new(rand(1..10)) }

    before(:create) do |package_sku|

      shop = package_sku.package_set.shop
      product = shop.products.first
      sku = product.skus.first

      package_sku.product = product
      package_sku.sku_id = sku.id

    end

  end
end
