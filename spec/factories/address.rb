FactoryGirl.define do

  factory :customer_address, class: Address do
    fname       '薇'
    lname       '李'
    additional  '309室'
    street      '华江里'
    number      '21'
    zip         '300222'
    city        '天津'
    country     'CN'
    email       'customer01@hotmail.com'
    mobile      '13802049778'
    province    '天津'
    district    '和平区'
    pid         { rand(100_000_000_000_000_000..999_999_999_999_999_999) }
  end


  factory :shop_address, class: Address do
    fname       { Faker::Name.first_name }
    lname       { Faker::Name.last_name }
    street      { Faker::Address.street_name }
    number      { rand(1..200) }
    zip         { Faker::Address.zip_code }
    city        { Faker::Address.city }
    country     'DE'
    email       { Faker::Internet.email }
    company     { Faker::Company.name }
    district    { Faker::Address.state }
    province    { Faker::Address.state }
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
