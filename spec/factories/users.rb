FactoryGirl.define do

  factory :admin, :class => User do

    role :admin
    username "admin_testing"
    email "admin@admin.com"
    birth "1978-01"
    gender "m"
    status true

    fname "Test"
    lname "User"
    country "GE"
    about "I don't know"
    website "http://www.mywebsite.com"
    tel "267823687"
    mobile "07890278927"


    password "12345678"
    #encrypted_password "$2a$10$s2dNnihkGCGAb9JGSigYduJdEccRdqJjs3JQjAmGYABJMpbt0qYw2"
    authentication_token "xfu16vcEYGBweBiN1FVL"

    current_sign_in_ip "127.0.0.1"

  end

  factory :shopkeeper, :class => User do
    role      :shopkeeper
    username  'dailycron'
    email     'dailycron@hotmail.com'
  end

  factory :user do

    role :customer
    username "mister_testing"
    email "user@user.com"
    birth "1978-01"
    gender "m"
    status true

    fname "Test"
    lname "User"
    country "GE"
    about "I don't know"
    website "http://www.mywebsite.com"
    tel "267823687"
    mobile "07890278927"

    password "12345678"
    #encrypted_password "$2a$10$s2dNnihkGCGAb9JGSigYduJdEccRdqJjs3JQjAmGYABJMpbt0qYw2"
    authentication_token "xfu16vcEYGBweBiN1FVL"

    current_sign_in_ip "127.0.0.1"

    addresses {[FactoryGirl.build(:customer_address)]}
    
  end
end
