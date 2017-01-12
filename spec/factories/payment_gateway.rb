FactoryGirl.define do
  factory :payment_gateway do

    payment_method :creditcard # default one
    merchant_id "1b3be510-a992-48aa-8af9-6ba4c368a0ac" # copied from wirecard config
    merchant_secret "33a67608-9822-43c2-acc1-faf2947b1be5"
    provider :wirecard
    shop_id { FactoryGirl.create(:shop).id }

    trait :with_upop do
      before(:create) do |payment_gateway|
        payment_gateway.payment_method = :upop
        payment_gateway.merchant_id = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
        payment_gateway.merchant_secret = "6cbfa34e-91a7-421a-8dde-069fc0f5e0b8"
      end
    end

  end
end
