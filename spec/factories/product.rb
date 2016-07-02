FactoryGirl.define do

  factory :product do

    name      'Product 1'
    brand     'Brand 1'
    cover     'Cover 1'
    desc      'Description 1'
    hs_code    "random"
    tags      ['tag1', 'tag2']

    options     {[FactoryGirl.build(:variant)]}
    skus        {[FactoryGirl.build(:sku, :option_ids => [self.options.first.suboptions.first.id.to_s])]}

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

  factory :variant,  :class => VariantOption do
    name 'Color'
    suboptions {[FactoryGirl.build(:option)]}
  end

  factory :option,  :class => VariantOption do
    name 'red'
  end

  factory :sku do
    price BigDecimal.new(11)
    quantity 2
    weight 0.1
    space_length 5
    space_width 4
    space_height 2
  end

end
