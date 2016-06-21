FactoryGirl.define do
  factory :shop do
    currency              'EUR'
    name                  'Seppls Lederhosenladen'
    shopname              'Seppls Lederhosenladen'
    founding_year         '1989'
    desc                  'Demo Shop'
    philosophy            'nothing'
    sales_channels        [:own_online_shop, 'www.taobao.com/123']
    fname                 'Thomas'
    lname                 'Kyte'
    tel                   '+89123434'
    mail                  'thomas.kyte@hotmail.com'

    #association :shopkeeper, factory: :shopkeeper, strategy: :build

    after(:create) do |shop|
      create_list(:product, 1, shop: shop)
      create_list(:shop_address, 1, shop: shop)
    end
  end
end
