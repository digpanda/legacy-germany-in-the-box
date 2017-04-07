FactoryGirl.define do
  factory :shipping_rate do

    price        50
    weight       10
    type         :general
    partner      :beihai

  end
end
