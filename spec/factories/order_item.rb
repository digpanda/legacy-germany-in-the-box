FactoryGirl.define do

  factory :order_item do

    product_name  "Product 1"
    option_names  ['red']
    price         BigDecimal.new(11)
    quantity      { rand(1..5) }
    weight        { rand(0.1..2.00) }

    after(:build) do |order_item, context|

      # contextual system to have the same shop between 
      # the order and the different products we will create
      shop = context.product[:shop]
      if shop
        product = create(:product, :shop_id => shop.id.to_s)
      else
        product = create(:product)
      end

      order_item.sku_id = product.skus.first.id.to_s
      order_item.option_ids = product.skus.first.option_ids
      order_item.product = product
      order_item.save

    end
  
  end

end
