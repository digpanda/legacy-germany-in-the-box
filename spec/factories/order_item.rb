FactoryGirl.define do

  factory :order_item do
    product_name  'Product 1'
    option_names  ['red']
    price         BigDecimal.new(11)
    quantity      1
    weight        0.1
    sku_id        {Shop.first.products.first.skus.first.id.to_s}
    option_ids    {Shop.first.products.first.skus.first.option_ids}
    product       {Shop.first.products.first}
  end

end
