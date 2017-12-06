FactoryGirl.define do

  factory :customer_address, class: Address do
    fname       '薇'
    lname       '李'
    full_address '天津和平区华江里21309室, 300222'
    country     :china
    email       'customer01@hotmail.com'
    mobile      '13802049778'
    pid         '11000019790225207X'
  end

  factory :shop_address, class: Address do
    fname       { Faker::Name.first_name }
    lname       { Faker::Name.last_name }
    full_address     { Faker::Address.street_name }
    country     :europe
    email       { Faker::Internet.email }
    company     { Faker::Company.name }
    mobile      { Faker::PhoneNumber.phone_number }
    type        :both

    trait :both do
      type :both
    end

    trait :sender do
      type :sender
    end

    trait :billing do
      type :billing
    end

  end
end
