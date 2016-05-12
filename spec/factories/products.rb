FactoryGirl.define do

  factory :product do

    name      'Product 1'
    brand     'Brand 1'
    cover     'Cover 1'
    desc      'Description 1'
    tags      ['tag1', 'tag2']

    options     {[FactoryGirl.build(:variant)]}
    skus        {[FactoryGirl.build(:sku, :option_ids => [self.options.first.suboptions.first.id.to_s])]}

    association :duty_category, factory: :duty_medicine_category, strategy: :build
  end

  factory :variant,  :class => VariantOption do
    name 'Color'
    suboptions {[FactoryGirl.build(:option)]}
  end

  factory :option,  :class => VariantOption do
    name 'red'
  end

  factory :sku do
    price 2.46
    quantity 2
    weight 1
    space_length 5
    space_width 5
    space_height 5
  end

end
