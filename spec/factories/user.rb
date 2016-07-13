FactoryGirl.define do

  factory :admin, :class => User do

    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    username               { "Admin#{Helpers::Global.next_number(:admin)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    role                   :admin
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

  end

  factory :shopkeeper, :class => User do

    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    username               { "Shopkeeper#{Helpers::Global.next_number(:shopkeeper)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    role                   :shopkeeper
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

    #association :shop, factory: :shop, strategy: :create

    after(:create) do |shopkeeper|
      create_list(:shop_address, 1, user: shopkeeper)
      create_list(:shop, 1, shopkeeper_id: shopkeeper.id) unless shopkeeper.shop
      shopkeeper.reload
    end

  end

  factory :customer, :class => User do

    # Should be chinese ? Investigate Faker to do so ...
    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    username               { "Customer#{Helpers::Global.next_number(:customer)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    role                   :customer
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

    after(:create) do |user|
      create_list(:customer_address, 1, user: user)
    end

    trait :with_orders do 

      after(:create) do |user|

        shop = create_list(:shop, 1).first
        create_list(:product, 10, shop: shop)
        create_list(:shop_address, 1, shop: shop)
        create_list(:order, 5, shop_id: shop.id, user_id: user.id)

      end

    end

    trait :with_favorites do
      after(:create) do |user|
        products = create_list(:product, 5)
        user.favorites = products
        user.save
      end
    end

  end

end
