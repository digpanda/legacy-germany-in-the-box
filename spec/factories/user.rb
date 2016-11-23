FactoryGirl.define do

  factory :customer, :class => User do

    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    username               { "Customer#{Helpers::Global.next_number(:customer)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

    factory :shopkeeper, :class => User do
      username               { "Shopkeeper#{Helpers::Global.next_number(:shopkeeper)}" }
      role                   :shopkeeper

      after(:create) do |shopkeeper|
        create(:shop_address, user: shopkeeper)
        create(:shop, shopkeeper_id: shopkeeper.id) unless shopkeeper.shop
        shopkeeper.reload
      end
    end

    factory :admin, :class => User do
      username               { "Admin#{Helpers::Global.next_number(:admin)}" }
      role                   :admin
    end

    after(:create) do |user|
      create(:customer_address, user: user)
    end

    trait :without_address do
      after(:create) do |user|
        user.addresses.delete_all # creation / destruction
      end
    end

    trait :with_orders do
      after(:create) do |user|
        shop = create(:shop)
        create(:shop_address, shop: shop)
        create_list(:product, 10, shop: shop)
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
