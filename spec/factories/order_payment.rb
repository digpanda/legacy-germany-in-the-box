FactoryGirl.define do
  factory :order_payment do

    request_id "63243a7a-8254-467b-9b86-57f03039f475"
    merchant_id "9105bb4f-ae68-4768-9c3b-3eda968f57ea"
    amount_cny 1048.65
    amount_eur 138.28
    origin_currency "CNY"
    order_id { FactoryGirl.create(:order).id }
    user_id { FactoryGirl.create(:customer).id }

    trait :with_scheduled do
      before(:create) do |order_payment|
        order_payment.parent_transaction_id = nil
        order_payment.transaction_id = nil
        order_payment.transaction_type = "purchase"
        order_payment.payment_method = nil
        order_payment.status = :scheduled
      end
    end

  end
end
