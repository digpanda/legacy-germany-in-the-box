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
    fname       'Thomas'
    lname       'Kyte'
    street      'Winibad str.'
    number      '72'
    zip         '85591'
    city        'Vaterstetten'
    country     'DE'
    tel         '+89123456'
    email       'shopkeeper01@hotmail.com'
    type        'both'
    company     'Supersoft'
    province    'Bayern'
  end
end