FactoryGirl.define do

  factory :sku do

    price { BigDecimal.new(rand(1..10)) }
    quantity 5
    weight { rand(0.01..3.00) }
    space_length { rand(1..4) }
    space_width { rand(1..4) }
    space_height { rand(1..4) }

    trait :with_small_volume do
      space_length 5
      space_width 15
      space_height 10
    end

    trait :with_big_volume do
      space_length 20
      space_width 20
      space_height 15
    end
    
  end

end