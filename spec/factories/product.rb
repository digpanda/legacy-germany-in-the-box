FactoryGirl.define do

  factory :product do

    name      { Faker::Commerce.product_name }
    brand     { FactoryGirl.create(:brand, name: 'Brand 1') }
    cover     'Cover 1'
    desc      { Faker::Lorem.paragraph }
    hs_code    'random'
    approved { Time.now }
    status true

    options   { [FactoryGirl.build(:variant)] }
    skus      { [FactoryGirl.build(:sku, option_ids: [self.options.first.suboptions.first.id.to_s])] }
    shop      { FactoryGirl.create(:shop) }

    association :duty_category, factory: :duty_medicine_category, strategy: :build

    before(:create) do |product|
      if product.categories.count == 0
        category = Category.offset(rand(Category.count)).first || FactoryGirl.create(:category)
        product.categories << category
        product.save
      end
    end

    before(:create) do |product|
      if product.duty_category_id.nil?
        product.duty_category_id = create_list(:duty_health_category, 1).first.id
        product.save
        product.reload
      end
    end

  end

  trait(:with_20_percent_discount) do
    skus { [FactoryGirl.build(:sku, option_ids: [self.options.first.suboptions.first.id.to_s], discount: 20)] }
  end

  trait(:with_small_volume) do
    skus { [FactoryGirl.build(:sku, :with_small_volume, option_ids: [self.options.first.suboptions.first.id.to_s])] }
  end

  trait(:with_big_volume) do
    skus { [FactoryGirl.build(:sku, :with_big_volume, option_ids: [self.options.first.suboptions.first.id.to_s])] }
  end

  factory :variant,  class: VariantOption do
    name 'Color'
    suboptions { [FactoryGirl.build(:option)] }
  end

  factory :option,  class: VariantOption do
    name 'red'
  end

end
