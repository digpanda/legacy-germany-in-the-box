FactoryGirl.define do

  factory :coupon, class: Coupon do

    code { Faker::Name.name }
    discount 10.0
    desc 'Random description'
    unit :percent
    minimum_order 1
    unique false

  end

end
