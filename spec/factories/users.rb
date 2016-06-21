FactoryGirl.define do

  factory :admin, :class => User do
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
      shop = FactoryGirl.build(:shop) # that's how you associate when you have an ORM which sucks.
      shop.shopkeeper_id = shopkeeper.id
      shop.save
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

  end

end
