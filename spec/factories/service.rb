FactoryGirl.define do

  factory :service, class: Service do

    name        { Faker::Name.name }
    desc        { Faker::Lorem.paragraph }
    long_desc   { Faker::Lorem.paragraph }
    cover       { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'banner', '850x400.png')) }
    category    { Category.offset(rand(Category.count)).first || FactoryGirl.create(:category) }
    brand       { FactoryGirl.create(:brand) }
    position    0

  end

end
