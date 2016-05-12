FactoryGirl.define do
  factory :order do
    border_guru_quote_id    'BG-DE-CN-01234567898'
    delivery_destination    {FactoryGirl.create(:customer_address)}

    after(:build) do |order|
      order.order_items = build_list :order_item, 2
    end
  end
end
