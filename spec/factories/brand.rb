FactoryGirl.define do

  factory :brand, class: Brand do

    name { Faker::Name.name }
    position { [*1..100].sample }
    used_as_filter true

    # after(:create) do |brand|
    #   unless brand.products.count > 0
    #     FactoryGirl.create_list(:product, 2, brand: brand)
    #   end
    # end

  end

end
