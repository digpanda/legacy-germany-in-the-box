FactoryGirl.define do
  factory :payment_gateway do

    payment_method :wechatpay
    provider :wechatpay
    shop_id { FactoryGirl.create(:shop).id }

    trait :with_wechatpay do
      before(:create) do |payment_gateway|
        payment_gateway.payment_method = :wechatpay
        payment_gateway.provider = :wechatpay
      end
    end

    trait :with_alipay do
      before(:create) do |payment_gateway|
        payment_gateway.payment_method = :alipay
        payment_gateway.provider = :alipay
      end
    end

  end
end
