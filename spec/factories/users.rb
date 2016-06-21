FactoryGirl.define do

  factory :admin, :class => User do
  end

  factory :shopkeeper, :class => User do
  end

  factory :customer, :class => User do

    fname                  "Customer"
    lname                  { "N#{Helpers::Global.next_number(:customer)}" }
    gender                 { Helpers::Global.random_gender }
    username               { "Customer#{Helpers::Global.next_number(:customer)}" }
    email                  { "customer#{Helpers::Global.next_number(:customer)}@customer.com" }
    password               '12345678'
    password_confirmation  '12345678'
    role                   :customer
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

=begin
    after(:create) do |user|
      create_list(:customer_address, 1, user: user)
    end
=end
  end

end
