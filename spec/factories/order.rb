FactoryGirl.define do
  factory :order do

    status                  :new
    desc                    { Faker::Lorem.paragraph }
    shipping_address        { FactoryGirl.build(:customer_address) }
    billing_address         { FactoryGirl.build(:customer_address) }
    shop                    { FactoryGirl.create(:shop) }
    user                    { FactoryGirl.create(:customer) }

    after(:build) do |order|
      order.order_items = build_list(:order_item, 5, :product => {:shop => order.shop})
    end

    trait :with_package_set do
      after(:create) do |order|
        order.order_items.delete_all
        package_set = FactoryGirl.create(:package_set, shop: order.shop)
        package_set.package_skus.each do |package_sku|
          FactoryGirl.create(:order_item, order: order, sku: package_sku.sku, package_set: package_set)
        end
      end
    end

    trait :with_package_sets do
      after(:create) do |order|
        order.order_items.delete_all
        package_sets = FactoryGirl.create_list(:package_set, 3, shop: order.shop)
        package_sets.each do |package_set|
            package_set.package_skus.each do |package_sku|
            FactoryGirl.create(:order_item, order: order, sku: package_sku.sku, package_set: package_set)
          end
        end
      end
    end

    trait :with_custom_checkable do
      status :custom_checkable
    end

    trait :with_referrer do
      referrer { FactoryGirl.create(:customer, :with_referrer, :from_wechat).referrer }

      after(:create) do |order|
        # we remove to better rebuild the items
        # with referrer rates
        order.order_items = []
        order.order_items = build_list(:order_item, 2, {:referrer_rate => 10.00})
        order.save
      end
    end

    trait :with_referrer_coupon do
      # it will resolve into `referrer` within this model
      coupon { FactoryGirl.create(:coupon, :with_referrer) }
      referrer { coupon.referrer }

      after(:create) do |order|
        # we remove to better rebuild the items
        # with referrer rates
        order.order_items = []
        order.order_items = build_list(:order_item, 2, {:referrer_rate => 10.00})
        order.save
      end
    end

    trait :with_shippable do
      status :custom_checking
    end

    trait :without_customer do
      after(:build) do |order|
        order.user = nil
      end
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
