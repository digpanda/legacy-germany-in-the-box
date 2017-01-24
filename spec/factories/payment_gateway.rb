FactoryGirl.define do
  factory :payment_gateway do

    payment_method :creditcard # default one
    merchant_id "9105bb4f-ae68-4768-9c3b-3eda968f57ea" # copied from wirecard config
    merchant_secret "d1efed51-4cb9-46a5-ba7b-0fdc87a66544"
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
