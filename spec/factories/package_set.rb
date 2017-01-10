FactoryGirl.define do
  factory :package_set do

    # border_guru_quote_id    'BG-DE-CN-01234567898'
    # status                  :new
    # border_guru_shipment_id 'TEST'

    name                    { Faker::Lorem.title }
    # shipping_address        { FactoryGirl.build(:customer_address) }
    # billing_address         { FactoryGirl.build(:customer_address) }
    # shop                    { FactoryGirl.create(:shop) }
    # user                    { FactoryGirl.create(:customer) }
    #
    # trait :with_custom_checkable do
    #   status :custom_checkable
    #   minimum_sending_date { 48.hours.from_now }
    # end
  end
end
