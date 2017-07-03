FactoryGirl.define do

  factory :shop, :class => Shop do

    name                  { "#{Faker::Company.name} #{Faker::Company.suffix}"  }
    shopname              { Faker::Company.name }
    founding_year         { Helpers::Global.random_year }
    desc                  { Faker::Company.catch_phrase }
    philosophy            { Faker::Company.bs }
    fname                 { Faker::Name.first_name }
    lname                 { Faker::Name.last_name }
    mail                  { Faker::Internet.email }
    approved { Time.now }
    addresses             { FactoryGirl.build_list(:shop_address, 2) }

    before(:create) do |shop|
      Faker::Config.locale = :de # to avoid weird chinese names
      create_list(:shopkeeper, 1, shop: shop) unless shop.shopkeeper_id
    end

    after(:create) do |shop|
      create_list(:product, 10, shop: shop)
      create_list(:shop_address, 1, shop: shop)
    end

  end

  trait(:with_payment_gateways) do
    after(:create) do |shop|
      create(:payment_gateway, :with_alipay, shop_id: shop.id)
      create(:payment_gateway, :with_wechatpay, shop_id: shop.id)
    end
  end

  trait(:with_orders) do
    after(:create) do |shop|
      create_list(:order, 5, shop_id: shop.id)
    end
  end

  trait(:with_custom_checkable_orders) do
    after(:create) do |shop|
      create_list(:order, 5, :with_custom_checkable, shop_id: shop.id)
    end
  end

  trait(:with_shippable_orders) do
    after(:create) do |shop|
      create_list(:order, 5, :with_shippable, shop_id: shop.id)
    end
  end

end
