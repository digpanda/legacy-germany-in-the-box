FactoryGirl.define do
  factory :package_sku do

    quantity 2
    price { BigDecimal.new(rand(1..10)) }
    taxes_per_unit { BigDecimal.new(rand(1..10)) }
    shipping_per_unit { BigDecimal.new(rand(1..10)) }

    before(:create) do |package_sku|
      shop = package_sku.package_set.shop
      product = shop.products.first
      sku = product.skus.first

      package_sku.product = product
      package_sku.sku_id = sku.id

    end
    #product { FactoryGirl.create(:product) }
    # sku_id { product.skus.first.id }


    # shipping_address        { FactoryGirl.build(:customer_address) }
    # billing_address         { FactoryGirl.build(:customer_address) }
    # shop                    { FactoryGirl.create(:shop) }
    # user                    { FactoryGirl.create(:customer) }
    #
    # trait :with_custom_checkable do
    #   status :custom_checkable
    #   minimum_sending_date { 48.hours.from_now }
    # end
  end
end
