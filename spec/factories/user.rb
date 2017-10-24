FactoryGirl.define do

  factory :customer, class: User do

    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    nickname               { "Customer#{Helpers::Global.next_number(:customer)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }
    addresses             { FactoryGirl.build_list(:customer_address, 2, primary: true) }

    factory :shopkeeper, class: User do
      nickname               { "Shopkeeper#{Helpers::Global.next_number(:shopkeeper)}" }
      role                   :shopkeeper

      after(:create) do |shopkeeper|
        create(:shop_address, user: shopkeeper)
        create(:shop, shopkeeper_id: shopkeeper.id) unless shopkeeper.shop
        shopkeeper.reload
      end
    end

    factory :admin, class: User do
      nickname               { "Admin#{Helpers::Global.next_number(:admin)}" }
      role                   :admin
    end

    trait :with_referrer do
      before(:create) do |user|
        Referrer.create(user: user, reference_id: SecureRandom.uuid, nickname: "Referrer#{Helpers::Global.next_number(:referrer)}", group: '')
      end
    end

    trait :from_wechat do
      before(:create) do |user|
        user.provider = :wechat
        user.wechat_unionid = '0123456789'
        user.wechat_openid = '0123456789'
        user.email = '0123456789@wechat.com'
      end
    end

    trait :without_name do
      before(:create) do |user|
        user.fname = nil
        user.lname = nil
      end
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
