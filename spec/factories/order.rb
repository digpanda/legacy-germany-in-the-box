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
      minimum_sending_date { 48.hours.from_now }
    end

    trait :with_shippable do
      status :custom_checking
      minimum_sending_date { 24.hours.ago }
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

    trait :with_one_small_item do
      after(:create) do |order|
        # we remove to better rebuild the items
        order.order_items = []
        order.order_items = build_list(:order_item, 1, :with_small_volume, :product => {:shop => order.shop})
        order.save
      end
    end

    trait :with_small_volume_items do
      after(:create) do |order|
        # we remove to better rebuild the items
        order.order_items = []
        order.order_items = build_list(:order_item, 5, :with_small_volume, :product => {:shop => order.shop})
        order.save
      end
    end

    trait :with_two_big_items do
      after(:create) do |order|
        # we remove to better rebuild the items
        order.order_items = []
        order.order_items = build_list(:order_item, 2, :with_big_volume, :product => {:shop => order.shop})
        order.save
      end
    end

    trait :with_big_volume_items do
      after(:create) do |order|
        # we remove to better rebuild the items
        order.order_items = []
        order.order_items = build_list(:order_item, 5, :with_big_volume, :product => {:shop => order.shop})
        order.save
      end
    end

    after(:create) do |order|
      order.order_items.each { |i| i.save } # buggy mongo for no fucking reason ?
    end

  end
end
