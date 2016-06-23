FactoryGirl.define do
  factory :shop, :class => Shop do
    currency              'EUR'
    name                  'Seppls Lederhosenladen'
    shopname              'Seppls Lederhosenladen'
    founding_year         '1989'
    desc                  'Demo Shop'
    philosophy            'nothing'
    fname                 'Thomas'
    lname                 'Kyte'
    tel                   '+89123434'
    mail                  'thomas.kyte@hotmail.com'

    before(:create) do |shop|
      create_list(:shopkeeper, 1, shop: shop) unless shop.shopkeeper_id
    end
    
    after(:create) do |shop|
      create_list(:product, 10, shop: shop)
      create_list(:shop_address, 1, shop: shop)
      shop.reload
    end
  end

  factory :shop_with_custom_checking_orders, :class => Shop do

    currency              'EUR'
    name                  'Seppls Lederhosenladen'
    shopname              'Seppls Lederhosenladen'
    founding_year         '1989'
    desc                  'Shop With Customer Checking Orders'
    philosophy            'nothing'
    fname                 'Thomas'
    lname                 'Kyte'
    tel                   '+89123434'
    mail                  'thomas.kyte@hotmail.com'

    before(:create) do |shop|
      create_list(:shopkeeper, 1, shop: shop) unless shop.shopkeeper_id
    end

    after(:create) do |shop|
      create_list(:product, 10, shop: shop)
      create_list(:shop_address, 1, shop: shop)
      create_list(:order, 5, :with_custom_checking, shop_id: shop.id)
      shop.reload
    end

  end
end
