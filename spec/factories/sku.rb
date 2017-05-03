FactoryGirl.define do

  # NOTE : please create a product
  # and then a sku, not the opposite
  # it won't work.
  factory :sku do

    price { BigDecimal.new(rand(1..10)) }
    quantity 5
    status true
    unlimited true
    weight { rand(0.01..3.00) }
    space_length { rand(1..4) }
    space_width { rand(1..4) }
    space_height { rand(1..4) }
    images { FactoryGirl.build_list(:image, 4) }

    # TODO : this should be removed after a while
    # img0 { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }
    # img1 { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }
    # img2 { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }
    # img3 { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }


    trait :with_small_volume do
      space_length 5
      space_width 5
      space_height 8
    end

    trait :with_big_volume do
      space_length 15
      space_width 20
      space_height 15
    end

  end

end
