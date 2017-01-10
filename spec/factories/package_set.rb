 FactoryGirl.define do
   factory :package_set do

     name                    { Faker::Name.name }
     shop                    { FactoryGirl.create(:shop) }

     after(:create) do |package_set|
       FactoryGirl.create_list(:package_sku, 5, package_set: package_set)
     end

   end
 end
