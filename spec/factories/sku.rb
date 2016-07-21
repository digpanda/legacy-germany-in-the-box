FactoryGirl.define do

  factory :sku do

    price BigDecimal.new(11)
    quantity 2
    weight 0.1
    space_length 5
    space_width 4
    space_height 2
    
  end

end