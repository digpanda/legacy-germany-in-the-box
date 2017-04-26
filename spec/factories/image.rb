FactoryGirl.define do
  factory :image do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }
  end
end
