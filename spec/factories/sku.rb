FactoryGirl.define do

  factory :sku do

    price { BigDecimal.new(rand(1..10)) }
    quantity 2
    weight { rand(0.01..3.00) }
    space_length { rand(1..4) }
    space_width { rand(1..4) }
    space_height { rand(1..4) }
    
  end

end