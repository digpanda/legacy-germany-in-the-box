FactoryGirl.define do
  factory :order do

    border_guru_quote_id    'BG-DE-CN-01234567898'
    status                  :new
    border_guru_shipment_id 'TEST'
    
    desc                    { Faker::Lorem.paragraph }
    shipping_address        { FactoryGirl.create(:customer_address) }
    billing_address         { FactoryGirl.create(:customer_address) }
    shop                    { FactoryGirl.create(:shop) }

    trait :with_custom_checking do
      status :custom_checking
      minimum_sending_date 1.hours.ago
    end

    after(:build) do |order|
      order.order_items = build_list(:order_item, 5, :product => {:shop => order.shop})
    end

    trait :without_item do
      # we remove afterwards because they are stored within the build and it's hard to prevent it
      after(:build) do |order|
        order.order_items = []
      end
    end

    after(:create) do |order|
      order.order_items.each { |i| i.save } # buggy mongo for no fucking reason ?
    end

  end
end
