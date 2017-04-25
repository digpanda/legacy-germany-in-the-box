FactoryGirl.define do

  # NOTE : please create a product
  # and then a sku, not the opposite
  # it won't work.
  factory :image do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'samples', 'images', 'product', '400x400.png')) }
  end
end
