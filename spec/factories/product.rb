FactoryGirl.define do

  factory :product do

    name      { Faker::Commerce.product_name }
    brand     "Brand 1"
    cover     "Cover 1"
    desc      { Faker::Lorem.paragraph }
    hs_code    "random"
    approved { Time.now }
    status true

    options   { [FactoryGirl.build(:variant)] }
    skus      { [FactoryGirl.build(:sku, :option_ids => [self.options.first.suboptions.first.id.to_s])] }

    association :duty_category, factory: :duty_medicine_category, strategy: :build

    before(:create) do |product|
      if product.categories.count == 0
        category = Category.offset(rand(Category.count)).first || FactoryGirl.create(:category)
        product.categories << category
        product.save
      end
    end

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

  trait(:with_20_percent_discount) do
    after(:create) do |product|
      # we apply the discount to each sku of the product
      product.skus.each do |sku|
        sku.discount = 20
        sku.save
      end
      product.save
      product.reload
    end
  end

  trait(:with_small_volume) do
    skus { [FactoryGirl.build(:sku, :with_small_volume, :option_ids => [self.options.first.suboptions.first.id.to_s])] }
  end

  trait(:with_big_volume) do
    skus { [FactoryGirl.build(:sku, :with_big_volume, :option_ids => [self.options.first.suboptions.first.id.to_s])] }
  end

  factory :variant,  :class => VariantOption do
    name 'Color'
    suboptions {[FactoryGirl.build(:option)]}
  end

  factory :option,  :class => VariantOption do
    name 'red'
  end

end
