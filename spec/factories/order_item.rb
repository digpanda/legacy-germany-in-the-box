FactoryGirl.define do

  factory :order_item do

    quantity 3

    after(:build) do |order_item, context|
      # contextual system to have the same shop between
      # the order and the different products we will create
      shop = context.product[:shop] if context.product && context.product[:shop]
      if shop
        product = create(:product, shop_id: shop.id.to_s)
      else
        product = create(:product)
      end

      sku = product.skus.first
      update_with_sku!(order_item, product, sku)

    end

    trait :with_small_volume do
      after(:build) do |order_item|
        product = create(:product, :with_small_volume)
        sku = product.skus.first
        update_with_sku!(order_item, product, sku)
      end
    end

    trait :with_big_volume do
      after(:build) do |order_item|
        product = create(:product, :with_big_volume)
        sku = product.skus.first
        update_with_sku!(order_item, product, sku)
      end
    end
  end

end

def update_with_sku!(order_item, product, sku)
  order_item.product = sku.product
  order_item.sku = sku.clone
  order_item.sku_origin = sku
  order_item.save
end
