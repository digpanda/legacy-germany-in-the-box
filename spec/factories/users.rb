FactoryGirl.define do

  factory :admin, :class => User do
  end

  factory :shopkeeper, :class => User do
  end

  factory :customer, :class => User do

    before(:create) do |address|
      #binding.pry
      #I18n.locale = :de
      #Faker::Config.locale = 'de'
      #binding.pry
    end

    fname                  { Faker::Name.first_name }
    lname                  { Faker::Name.last_name }
    gender                 { Helpers::Global.random_gender }
    username               { "Customer#{Helpers::Global.next_number(:customer)}" }
    email                  { Faker::Internet.email }
    password               '12345678'
    password_confirmation  '12345678'
    role                   :customer
    tel                    { Faker::PhoneNumber.phone_number }
    mobile                 { Faker::PhoneNumber.cell_phone }
    birth                  { Helpers::Global.random_date }

    after(:create) do |user|
      create_list(:customer_address, 1, user: user)
    end

  end

end
