FactoryGirl.define do
  factory :order_tracking do

    delivery_id '000'
    delivery_provider 'ems'
    state :new
    order_id { FactoryGirl.create(:order).id }

    trait :with_recent_refresh do
      before(:create) do |order_tracking|
        order_tracking.refreshed_at = 5.minutes.ago
      end
    end

    trait :with_old_refresh do
      before(:create) do |order_tracking|
        order_tracking.refreshed_at = 1.day.ago
      end
    end

  end
end
