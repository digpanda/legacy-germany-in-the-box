FactoryGirl.define do

  factory :coupon, class: Coupon do

    code { Faker::Name.name }
    discount 10.0
    desc 'Random description'
    unit :percent
    minimum_order 1
    unique false

    trait :with_referrer do
      referrer { FactoryGirl.create(:customer, :with_referrer, :from_wechat).referrer }
    end

  end

end
