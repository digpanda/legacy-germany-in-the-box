FactoryGirl.define do

  factory :product do

    name      { Faker::Commerce.product_name }
    brand     "Brand 1"
    cover     "Cover 1"
    desc      { Faker::Lorem.paragraph }
    hs_code    "random"
    tags      ["tag1", "tag2"]

    options   { [FactoryGirl.build(:variant)] }
    skus      { [FactoryGirl.build(:sku, :option_ids => [self.options.first.suboptions.first.id.to_s])] }

    association :duty_category, factory: :duty_medicine_category, strategy: :build

    before(:create) do |product|
      if product.shop_id.nil?
        product.shop_id = create_list(:shop, 1).first.id
        product.save
        product.reload
      end
      if product.duty_category_id.nil?
        product.duty_category_id = create_list(:duty_health_category, 1).first.id
        product.save
        product.reload
      end
    end

  end

  trait(:with_small_volume) do
    before(:create) do |product|
      # remove and make new skus
      product.skus = [FactoryGirl.build(:sku, :with_small_volume, :option_ids => [product.options.first.suboptions.first.id.to_s])]
    end
  end

  trait(:with_big_volume) do
    before(:create) do |product|
      # remove and make new skus
      product.skus = [FactoryGirl.build(:sku, :with_big_volume, :option_ids => [product.options.first.suboptions.first.id.to_s])]
    end
  end

  factory :variant,  :class => VariantOption do
    name 'Color'
    suboptions {[FactoryGirl.build(:option)]}
  end

  factory :option,  :class => VariantOption do
    name 'red'
  end

end
