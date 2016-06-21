FactoryGirl.define do

  factory :customer_address, class: Address do
    fname       '薇'
    lname       '李'
    pid         { rand(100_000_000_000_000_000..999_999_999_999_999_999) }
    additional  '309室'
    street      '华江里'
    number      '21'
    zip         '300222'
    city        '天津'
    country     'CN'
    tel         '+86123456'
    email       'customer01@hotmail.com'
    mobile      '13802049778'
    province    '天津'
    district    '和平区'
  end

  factory :shop_address, class: Address do
    
    fname       { Faker::Name.first_name }
    lname       { Faker::Name.last_name }
    street      { Faker::Address.street_name }
    number      { rand(1..200) }
    zip         { Faker::Address.zip_code }
    city        { Faker::Address.city }
    country     'DE'
    tel         { Faker::PhonNumber.phone_number }
    email       { Faker::Internet.email }
    company     { Faker::Company.name }
    province    { Faker::Adress.state }
    type        'both'
  end
end

