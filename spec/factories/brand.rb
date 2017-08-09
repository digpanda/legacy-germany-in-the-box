FactoryGirl.define do

  factory :brand, class: Brand do

    name { Faker::Name.name }
    position { [*1..100].sample }

    # TODO : try to find out why this generation does not work.
    #
    # products { FactoryGirl.create_list(:product, 2) }

    # after(:create) do |brand|
    #   create_list(:product, 2, brand: brand)
    # end

  end

end
