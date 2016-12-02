FactoryGirl.define do

  factory :order_item do

    option_names  ['red']
    quantity      3

    after(:build) do |order_item, context|
      # contextual system to have the same shop between
      # the order and the different products we will create
      shop = context.product[:shop] if context.product && context.product[:shop]
      if shop
        product = create(:product, :shop_id => shop.id.to_s)
      else
        product = create(:product)
      end

      sku = product.skus.first
      order_item.product.name  = product.name
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
  order_item.price = sku.price
  order_item.weight = sku.weight
  order_item.sku = sku
  order_item.option_ids = sku.option_ids
  order_item.product = product
  order_item.save
end
