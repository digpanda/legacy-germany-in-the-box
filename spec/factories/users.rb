FactoryGirl.define do
  factory :user do

    username "test_user"
    email "testing@testing.com"
    birth "1978-01-01"
    gender "m"
    status true

=begin
    trait :published do
      status :published
    end

    trait :unpublished do
      status :unpublished
    end

    trait :in_the_future do
      published_at { 2.days.from_now }
    end

    trait :in_the_past do
      published_at { 2.days.ago }
    end
=end
  end

end
