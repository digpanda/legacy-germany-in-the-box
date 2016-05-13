FactoryGirl.define do
  factory :order do
    border_guru_quote_id    'BG-DE-CN-01234567898'
    shipping_address        {FactoryGirl.create(:customer_address)}
    billing_address         {FactoryGirl.create(:customer_address)}

    after(:build) do |order|
      order.order_items = build_list :order_item, 2
    end
  end
end
