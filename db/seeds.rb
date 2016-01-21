User.where(:email => 'dailycron@hotmail.com').each do |u|
    u.oCollections.delete_all
end

User.where(:email => 'dailycron@hotmail.com').each do |u|
  u.oCollections.create!(:name => 'My Son', :public => true)
  u.oCollections.create!(:name => 'My Wife', :public => false)
end

Order.all.delete

Address.all.delete

Category.all.delete

#
# root categories - level 0
#
category_fashion = Category.create!(
    :name => 'Fashion'
)

category_food = Category.create!(
    :name => 'Food'
)

category_toys_home = Category.create!(
    :name => 'Toys & Home'
)


#
# bags & accessories category - level 1
#
category_bags_accessories = Category.create!(
    :name => 'Bags & Accessories',
    :code => 'L1-1',
    :cssc => 'fa-umbrella',
    :parent => category_fashion
)

Category.create!(
    :name => 'Belts',
    :code => 'L2-251',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Bag Accessories',
    :code => 'L2-291',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Gloves & Ear Muffs',
    :code => 'L2-404',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Sunglasses',
    :code => 'L2-406',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Briefcases, School Satchels & Messenger Bags',
    :code => 'L2-624',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Handbags, Clutches & Shoulder Bags',
    :code => 'L2-626',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Purses, Pouches & Wallets',
    :code => 'L2-627',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags',
    :code => 'L2-628',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Scarves, Shawls & Veils',
    :code => 'L2-645',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Key Rings & Moneyclips',
    :code => 'L2-646',
    :parent => category_bags_accessories
)


Category.create!(
    :name => 'Wristbands',
    :code => 'L2-649',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Other Accessories',
    :code => 'L2-244',
    :parent => category_bags_accessories
)


#
# clothes for men category - level 1
#
category_clothes_for_men = Category.create!(
    :name => 'Clothes for Men',
    :code => 'L1-47',
    :cssc => 'fa-male',
    :parent => category_fashion
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-63',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair',
    :code => 'L2-48',
    :parent => category_clothes_for_men
)


Category.create!(
    :name => 'Suits, Suit Jackets & Blazers',
    :code => 'L2-50',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-53',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'T-Shirts, Shirts & Polos',
    :code => 'L2-51',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'Trousers, Shorts & Jeans',
    :code => 'L2-52',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'Outerwear, Knitted',
    :code => 'L2-596',
    :parent => category_clothes_for_men
)

Category.create!(
    :name => 'Outerwear, Leather, Fur & Plastic',
    :code => 'L2-669',
    :parent => category_clothes_for_men
)


#
# clothes for women category - level 1
#
category_clothes_for_women = Category.create!(
    :name => 'Clothes for Women',
    :code => 'L1-64',
    :cssc => 'fa-female',
    :parent => category_fashion
)

Category.create!(
    :name => 'Body Shapers',
    :code => 'L2-245',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Outerwear & Woven Other Textile Materials',
    :code => 'L2-66',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Dresses',
    :code => 'L2-77',
    :parent => category_clothes_for_women
)


Category.create!(
    :name => 'Lingerie',
    :code => 'L2-80',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Skirts, Skorts & Culottes',
    :code => 'L2-75',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Suits, Suit Jackets & Blazers',
    :code => 'L2-248',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-78',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-246',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Trousers, Shorts & Jeans',
    :code => 'L2-79',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Wedding & Prom Dresses',
    :code => 'L2-81',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Outerwear & Knitted',
    :code => 'L2-591',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Outerwear, Leather, Fur & Plastic',
    :code => 'L2-670',
    :parent => category_clothes_for_women
)

Category.create!(
    :name => 'Other Garments',
    :code => 'L2-593',
    :parent => category_clothes_for_women
)

#
# clothes for babies & essentials - level 1
#
category_clothes_for_babies_essentials = Category.create!(
    :name => 'Clothes for Babies & Essentials',
    :code => 'L1-331',
    :cssc => 'fa-smile-o',
    :parent => category_fashion
)

Category.create!(
    :name => 'Baby Clothes of cotton',
    :code => 'L2-332',
    :parent => category_clothes_for_babies_essentials
)

Category.create!(
    :name => 'Baby Clothes of Synthetic Fibre',
    :code => 'L2-334',
    :parent => category_clothes_for_babies_essentials
)


Category.create!(
    :name => 'Baby Essentials',
    :code => 'L2-356',
    :parent => category_clothes_for_babies_essentials
)

#
# clothes for children - level 1
#
category_clothes_for_children = Category.create!(
    :name => 'Clothes for Children',
    :code => 'L1-414',
    :cssc => 'fa-child',
    :parent => category_fashion
)

Category.create!(
    :name => 'Outerwear',
    :code => 'L2-415',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Suits, Jackets & Dresses',
    :code => 'L2-428',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-446',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-452',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'T-Shirts, Shirts & Blouses',
    :code => 'L2-462',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Trousers, Jeans & Skirts',
    :code => 'L2-474',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Underwear & Sleepwear',
    :code => 'L2-522',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Used & Worn Clothing',
    :code => 'L2-541',
    :parent => category_clothes_for_children
)

Category.create!(
    :name => 'Socks & Tights',
    :code => 'L2-606',
    :parent => category_clothes_for_children
)


#
# health & beauty category - level 1
#
category_health_beauty = Category.create!(
    :name => 'Health & Beauty',
    :code => 'L1-84',
    :cssc => 'fa-stethoscope ',
    :parent => category_fashion
)

Category.create!(
    :name => 'Bath & Shower',
    :code => 'L2-278',
    :parent => category_health_beauty
)

Category.create!(
    :name => 'Fragrances',
    :code => 'L2-91',
    :parent => category_health_beauty
)

Category.create!(
    :name => 'Hair Care',
    :code => 'L2-92',
    :parent => category_health_beauty
)

Category.create!(
    :name => 'Skin Care, Cosmetics & Tanning',
    :code => 'L2-94',
    :parent => category_health_beauty
)

Category.create!(
    :name => 'Supplements',
    :code => 'L2-277',
    :parent => category_health_beauty
)

Category.create!(
    :name => 'Massage & Orthopaedic',
    :code => 'L2-662',
    :parent => category_health_beauty
)


#
# home & garden category - level 1
#
category_home_garden = Category.create!(
    :name => 'Home & Garden',
    :code => 'L1-150',
    :cssc => 'fa-home',
    :parent => category_toys_home
)

category_home_accessories = Category.create!(
    :name => 'Home Accessories',
    :code => 'L2-273',
    :parent => category_home_garden
)

Category.create!(
    :name => 'Kitchen Accessories',
    :code => 'L2-275',
    :parent => category_home_garden
)

Category.create!(
    :name => 'Lighting',
    :code => 'L2-173',
    :parent => category_home_garden
)


Category.create!(
    :name => 'Furniture & Baby Furniture',
    :code => 'L2-388',
    :parent => category_home_garden
)


Category.create!(
    :name => 'Kitchenware & Tableware',
    :code => 'L2-639',
    :parent => category_home_garden
)

Category.create!(
    :name => 'Cutlery & Kitchen Utensils',
    :code => 'L2-640',
    :parent => category_home_garden
)


Category.create!(
    :name => 'Cookware',
    :code => 'L2-641',
    :parent => category_home_garden
)

#
# jewellery & watches category - level 1
#
category_jewellery_watches = Category.create!(
    :name => 'Jewellery & Watches',
    :code => 'L1-321',
    :cssc => 'fa-clock-o',
    :parent => category_fashion
)

Category.create!(
    :name => 'Jewellery of Precious Metals',
    :code => 'L2-322',
    :parent => category_jewellery_watches
)

Category.create!(
    :name => 'Pearls, Precious & Semiprecious Stones',
    :code => 'L2-325',
    :parent => category_jewellery_watches
)

Category.create!(
    :name => 'Clocks',
    :code => 'L2-561',
    :parent => category_jewellery_watches
)

Category.create!(
    :name => 'Watch & Clock Parts',
    :code => 'L2-563',
    :parent => category_jewellery_watches
)

#
# toys & games category - level 1
#
category_toys_games = Category.create!(
    :name => 'Toys & Games',
    :code => 'L1-329',
    :cssc => ' fa-gamepad',
    :parent => category_toys_home
)

Category.create!(
    :name => 'Figures & Dolls',
    :code => 'L2-220',
    :parent => category_toys_games
)

Category.create!(
    :name => 'Model Vehicles, Slot Racing & Radio-Controlled Toys',
    :code => 'L2-227',
    :parent => category_toys_games
)

Category.create!(
    :name => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys',
    :code => 'L2-664',
    :parent => category_toys_games
)

Category.create!(
    :name => 'Other Toys & Games',
    :code => 'L2-229',
    :parent => category_toys_games
)

#
# food & drink category - level 1
#
category_food_drinks = Category.create!(
    :name => 'Food & Drinks',
    :code => 'L1-578',
    :cssc => 'fa-cutlery',
    :parent => category_food
)

Category.create!(
    :name => 'Non-alcoholic Beverages',
    :code => 'L2-97',
    :parent => category_food_drinks
)

Category.create!(
    :name => 'Spirits',
    :code => 'L2-587',
    :parent => category_food_drinks
)

Category.create!(
    :name => 'Sweets, Snacks & Confectionery',
    :code => 'L2-633',
    :parent => category_food_drinks
)

Category.create!(
    :name => 'Fruit, Nuts, Seeds & Vegetables',
    :code => 'L2-635',
    :parent => category_food_drinks
)

Category.create!(
    :name => 'Jams, Honey & Spreads',
    :code => 'L2-665',
    :parent => category_food_drinks
)

Category.create!(
    :name => 'Oils, Herbs & Spices',
    :code => 'L2-666',
    :parent => category_food_drinks
)

#
# category shoes & footwear - level 1
#
category_shoes_footwear = Category.create!(
    :name => 'Shoes & Footwear',
    :code => 'L1-661',
    :cssc => 'fa-gift',
    :parent => category_fashion
)

Category.create!(
    :name => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins',
    :code => 'L2-543',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins',
    :code => 'L2-602',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins',
    :code => 'L2-603',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Men | house slippers',
    :code => 'L2-613',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Women | house slippers',
    :code => 'L2-616',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Boots & High Tops',
    :code => 'L2-619',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Children | House Slippers',
    :code => 'L2-620',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Children | Sandals & Flip Flops',
    :code => 'L2-621',
    :parent => category_shoes_footwear
)

Category.create!(
    :name => 'Other Footwear',
    :code => 'L2-600',
    :parent => category_shoes_footwear
)


#
# creates image upload file
#
def create_upload_from_image_file(model, image_name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
  file.original_filename = image_name
  file.content_type = content_type
  file
end

Shop.where(:name => 'Herz-Buffet').delete;
Product.where(:name => '10 Blatt Seidenpapier ♥ Panda ♥').all.delete;
Product.where({:name => /.*熊猫壁纸.*/i}).all.delete;

shop = Shop.create!(
    :name => 'Herz-Buffet',
    :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
    :logo => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
    :banner => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg')
);

product = shop.products.create!(
    :name => '10 Blatt Seidenpapier ♥ Panda ♥',
    :desc => %Q{
  ♥ 10 Bögen Seidenpapier
  ♥ Panda
  ♥ Größe je Bogen: 50 x 70cm
  ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
  ♥ Das Papier wird auf 18x25cm gefaltet versendet
  },
    :img => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/square_130.JPEG',
    :imglg => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :price => 10.0,
    :brand => 'Herz-Buffet',
    :tags => ['壁纸', '熊猫', 'buffet']

)

product.categories << category_home_accessories
product.save!

product = shop.products.create!(
    :name => '熊猫壁纸',
    :desc => '熊猫壁纸',
    :img => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/square_130.JPEG',
    :imglg => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :price => 10.0,
    :brand => 'Herz-Buffet',
    :tags => ['壁纸', '熊猫', 'buffet']
)

product.categories << category_home_accessories
product.save!