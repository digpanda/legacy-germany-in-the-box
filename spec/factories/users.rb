require 'faker'

FactoryGirl.define do

  factory :admin, :class => User do

  end

  factory :shopkeeper, :class => User do

  end

  symbol = :customer
  num = User.where(:role => symbol).count + 1

  def random_date
    Time.at(rand * Time.now.to_i).strftime("%F")
  end

  def random_year
    Time.at(rand * Time.now.to_i).year
  end

  factory :customer do

    fname                  name
    lname                  "N#{num}"
    gender                 ['f', 'm'].sample
    username               "#{name}#{num}"
    email                  "#{symbol}#{num}@#{symbol}.com"
    password               '12345678'
    password_confirmation  '12345678'
    role                   symbol
    tel                    Faker::PhoneNumber.phone_number
    mobile                 Faker::PhoneNumber.cell_phone
    birth                  random_date

=begin
    after(:create) do |user|
      create_list(:customer_address, 1, user: user)
    end
=end
  end
end
