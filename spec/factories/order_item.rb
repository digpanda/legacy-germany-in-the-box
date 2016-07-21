FactoryGirl.define do

  factory :order_item do

    option_names  ['red']
    quantity      { rand(1..5) }

    after(:build) do |order_item, context|

      # contextual system to have the same shop between 
      # the order and the different products we will create
      shop = context.product[:shop]
      if shop
        product = create(:product, :shop_id => shop.id.to_s)
      else
        product = create(:product)
      end

      order_item.product_name  = product.name
      order_item.price = product.skus.first.price
      order_item.weight = product.skus.first.weight
      order_item.sku_id = product.skus.first.id.to_s
      order_item.option_ids = product.skus.first.option_ids
      order_item.product = product
      order_item.save

    end
  
  end

end
