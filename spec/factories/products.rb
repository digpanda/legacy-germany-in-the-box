FactoryGirl.define do

  factory :product do

    name "Product 1"
    brand "Brand 1"
    cover "Cover 1"
    desc "Description 1"
    tags ['tag1', 'tag2']
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
