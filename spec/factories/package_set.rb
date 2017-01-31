 FactoryGirl.define do
   factory :package_set do

     name        { Faker::Name.name }
     shop        { FactoryGirl.create(:shop, :with_payment_gateways) }
     desc        { Faker::Lorem.paragraph }
     cover       { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'banner', '850x400.png')) }

     after(:create) do |package_set|
       FactoryGirl.create_list(:package_sku, 5, package_set: package_set)
     end

     trait :with_500_euro_total do
       after(:create) do |package_set|
         package_set.package_skus.delete_all
         FactoryGirl.create_list(:package_sku, 5, package_set: package_set, quantity: 1, price: 100)
       end
     end

   end
 end
