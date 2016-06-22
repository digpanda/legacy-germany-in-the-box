FactoryGirl.define do
  factory :order do
    border_guru_quote_id    'BG-DE-CN-01234567898'
    status                  :new
    shipping_address        {FactoryGirl.create(:customer_address)}
    billing_address         {FactoryGirl.create(:customer_address)}

    trait :with_custom_checking do
      status :custom_checking
    end

    after(:build) do |order|
      order.order_items = build_list :order_item, 2
    end


  end
end
