FactoryGirl.define do

  factory :brand, class: Brand do

    name { Faker::Name.name }
    position { [*1..100].sample }
    # products { FactoryGirl.create_list(:product, 2) } <!-- not working properly

  end

end
