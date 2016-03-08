User.where(:email => 'dailycron@hotmail.com').each do |u|
    u.oCollections.delete_all
end

User.where(:email => 'dailycron@hotmail.com').each do |u|
  u.oCollections.create!(:name => 'My Son', :public => true)
  u.oCollections.create!(:name => 'My Wife', :public => false)
end

Address.all.delete

OrderItem.all.delete

Order.all.delete

Category.all.delete

#
# root category - level 0
#
category_fashion = Category.create!(
    :name => 'Fashion',
    :name_locales => { :'zh-CN' => '时尚', :de => 'Mode'}
)

category_food = Category.create!(
    :name => 'Food',
    :name_locales => { :'zh-CN' => '食品和饮料', :de => 'Lebensmittel'}
)

category_toys_home = Category.create!(
    :name => 'Toys & Home',
    :name_locales => { :'zh-CN' => '玩具和家居', :de => 'Spielzeuge & Heim'}
)


#
# bags & accessories category - level 1
#
category_bags_accessories = Category.create!(
    :name => 'Bags & Accessories',
    :code => 'L1-1',
    :cssc => 'fa-umbrella',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '包包 & 配饰', :de => 'Taschen & Accessoires'}
)

Category.create!(
    :name => 'Belts',
    :code => 'L2-251',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '腰带', :de => 'Gürtel'}
)

Category.create!(
    :name => 'Bag Accessories',
    :code => 'L2-291',
    :parent => category_bags_accessories,
    :status => false
)

Category.create!(
    :name => 'Gloves & Ear Muffs',
    :code => 'L2-404',
    :parent => category_bags_accessories,
    :status => false
)

Category.create!(
    :name => 'Sunglasses',
    :code => 'L2-406',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '太阳镜', :de => 'Sonnenbrillen'}
)

Category.create!(
    :name => 'Briefcases, School Satchels & Messenger Bags',
    :code => 'L2-624',
    :parent => category_bags_accessories,
    :status => false
)

Category.create!(
    :name => 'Handbags, Clutches & Shoulder Bags',
    :code => 'L2-626',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '手包 & 背包', :de => 'Handtaschen & Umhängetaschen'}
)

Category.create!(
    :name => 'Purses, Pouches & Wallets',
    :code => 'L2-627',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '钱包 & 小包', :de => 'Portemonnaies & Pouches'}
)

Category.create!(
    :name => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags',
    :code => 'L2-628',
    :parent => category_bags_accessories,
    :status => false
)

Category.create!(
    :name => 'Scarves, Shawls & Veils',
    :code => 'L2-645',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '围巾 & 披肩', :de => 'Tücher & Schleier'}
)

Category.create!(
    :name => 'Key Rings & Moneyclips',
    :code => 'L2-646',
    :parent => category_bags_accessories,
    :status => false
)


Category.create!(
    :name => 'Wristbands',
    :code => 'L2-649',
    :parent => category_bags_accessories,
    :status => false
)

Category.create!(
    :name => 'Other Accessories',
    :code => 'L2-244',
    :parent => category_bags_accessories,
    :name_locales => { :'zh-CN' => '其他配饰', :de => 'Andere Accessoires'}
)


#
# clothes for men category - level 1
#
category_clothes_for_men = Category.create!(
    :name => 'Clothes for Men',
    :code => 'L1-47',
    :cssc => 'fa-male',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '男性时尚', :de => 'Herrenmode'},
    :status => false
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-63',
    :parent => category_clothes_for_men,
    :status => false
)

Category.create!(
    :name => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair',
    :code => 'L2-48',
    :parent => category_clothes_for_men,
    :status => false
)


Category.create!(
    :name => 'Suits, Suit Jackets & Blazers',
    :code => 'L2-50',
    :parent => category_clothes_for_men,
    :status => false
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-53',
    :parent => category_clothes_for_men,
    :status => false
)

Category.create!(
    :name => 'T-Shirts, Shirts & Polos',
    :code => 'L2-51',
    :parent => category_clothes_for_men,
    :name_locales => { :'zh-CN' => '体恤 & Polo衫', :de => 'T-Shirts & Poloshirts'}
)

Category.create!(
    :name => 'Trousers, Shorts & Jeans',
    :code => 'L2-52',
    :parent => category_clothes_for_men,
    :status => false
)

Category.create!(
    :name => 'Outerwear, Knitted',
    :code => 'L2-596',
    :parent => category_clothes_for_men,
    :name_locales => { :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :name => 'Outerwear, Leather, Fur & Plastic',
    :code => 'L2-669',
    :parent => category_clothes_for_men,
    :status => false
)


#
# clothes for women category - level 1
#
category_clothes_for_women = Category.create!(
    :name => 'Clothes for Women',
    :code => 'L1-64',
    :cssc => 'fa-female',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '女性时尚', :de => 'Damenmode'}
)

Category.create!(
    :name => 'Body Shapers',
    :code => 'L2-245',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Outerwear & Woven Other Textile Materials',
    :code => 'L2-66',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Dresses',
    :code => 'L2-77',
    :parent => category_clothes_for_women,
    :name_locales => { :'zh-CN' => '连衣裙', :de => 'Kleider'}
)


Category.create!(
    :name => 'Lingerie',
    :code => 'L2-80',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Skirts, Skorts & Culottes',
    :code => 'L2-75',
    :parent => category_clothes_for_women,
    :name_locales => { :'zh-CN' => '短裙 & 裤裙', :de => 'Röcke & Hosenröcke'}
)

Category.create!(
    :name => 'Suits, Suit Jackets & Blazers',
    :code => 'L2-248',
    :parent => category_clothes_for_women,
    :name_locales => { :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Jackets'}
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-78',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-246',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Trousers, Shorts & Jeans',
    :code => 'L2-79',
    :parent => category_clothes_for_women,
    :name_locales => { :'zh-CN' => '长短裤 & 牛仔', :de => 'Hosen & Kurzhosen'}
)

Category.create!(
    :name => 'Wedding & Prom Dresses',
    :code => 'L2-81',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Outerwear & Knitted',
    :code => 'L2-591',
    :parent => category_clothes_for_women,
    :name_locales => { :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :name => 'Outerwear, Leather, Fur & Plastic',
    :code => 'L2-670',
    :parent => category_clothes_for_women,
    :status => false
)

Category.create!(
    :name => 'Other Garments',
    :code => 'L2-593',
    :parent => category_clothes_for_women,
    :status => false
)

#
# clothes for babies & essentials - level 1
#
category_clothes_for_babies_essentials = Category.create!(
    :name => 'Clothes for Babies & Essentials',
    :code => 'L1-331',
    :cssc => 'fa-smile-o',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '婴儿衣装 & 用品', :de => 'Babybekleidung & Babybedarf'}
)

Category.create!(
    :name => 'Baby Clothes of cotton',
    :code => 'L2-332',
    :parent => category_clothes_for_babies_essentials,
    :name_locales => { :'zh-CN' => '婴儿衣装', :de => 'Babybekleidungen'}
)

Category.create!(
    :name => 'Baby Clothes of Synthetic Fibre',
    :code => 'L2-334',
    :parent => category_clothes_for_babies_essentials,
    :status => false
)


Category.create!(
    :name => 'Baby Essentials',
    :code => 'L2-356',
    :parent => category_clothes_for_babies_essentials,
    :name_locales => { :'zh-CN' => '婴儿用品', :de => 'Babybedarf'}
)

#
# clothes for children - level 1
#
category_clothes_for_children = Category.create!(
    :name => 'Clothes for Children',
    :code => 'L1-414',
    :cssc => 'fa-child',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '儿童时尚', :de => 'Kindermode'}
)

Category.create!(
    :name => 'Outerwear',
    :code => 'L2-415',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '外衣', :de => 'Oberkleidungen'}
)

Category.create!(
    :name => 'Suits, Jackets & Dresses',
    :code => 'L2-428',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Kleider'}
)

Category.create!(
    :name => 'Sweaters & Sweatshirts',
    :code => 'L2-446',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '毛衣 & 运动衫', :de => 'Pullis & Sweatshirts'}
)

Category.create!(
    :name => 'Swimwear & Leisurewear',
    :code => 'L2-452',
    :parent => category_clothes_for_children,
    :status => false
)

Category.create!(
    :name => 'T-Shirts, Shirts & Blouses',
    :code => 'L2-462',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '体恤衫 & 女衬衫', :de => 'T-Shirts & Blusen'}
)

Category.create!(
    :name => 'Trousers, Jeans & Skirts',
    :code => 'L2-474',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '长裤 & 裙子', :de => 'Hosen & Röcke'}
)

Category.create!(
    :name => 'Underwear & Sleepwear',
    :code => 'L2-522',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '内衣 & 睡衣', :de => 'Unterwäschen & Nachtwäsche'}
)

Category.create!(
    :name => 'Used & Worn Clothing',
    :code => 'L2-541',
    :parent => category_clothes_for_children,
    :status => false
)

Category.create!(
    :name => 'Socks & Tights',
    :code => 'L2-606',
    :parent => category_clothes_for_children,
    :name_locales => { :'zh-CN' => '袜子 & 裤袜', :de => 'Socken & Strumpfhosen'}
)


#
# health & beauty category - level 1
#
category_health_beauty = Category.create!(
    :name => 'Health & Beauty',
    :code => 'L1-84',
    :cssc => 'fa-stethoscope ',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege'}
)

Category.create!(
    :name => 'Bath & Shower',
    :code => 'L2-278',
    :parent => category_health_beauty,
    :name_locales => { :'zh-CN' => '沐浴', :de => 'Bad & Dusche'}
)

Category.create!(
    :name => 'Fragrances',
    :code => 'L2-91',
    :parent => category_health_beauty,
    :status => false
)

Category.create!(
    :name => 'Hair Care',
    :code => 'L2-92',
    :parent => category_health_beauty,
    :name_locales => { :'zh-CN' => '护发', :de => 'Haarpflege'}
)

Category.create!(
    :name => 'Skin Care, Cosmetics & Tanning',
    :code => 'L2-94',
    :parent => category_health_beauty,
    :name_locales => { :'zh-CN' => '护肤 & 化妆品', :de => 'Hautpflege & Kosmetik'}
)

Category.create!(
    :name => 'Supplements',
    :code => 'L2-277',
    :parent => category_health_beauty,
    :name_locales => { :'zh-CN' => '增补品', :de => 'Ergänzungen'}
)

Category.create!(
    :name => 'Massage & Orthopaedic',
    :code => 'L2-662',
    :parent => category_health_beauty,
    :name_locales => { :'zh-CN' => '按摩用品', :de => 'Massage & Orthopädie'}
)


#
# home & garden category - level 1
#
category_home_garden = Category.create!(
    :name => 'Home & Garden',
    :code => 'L1-150',
    :cssc => 'fa-home',
    :parent => category_toys_home,
    :name_locales => { :'zh-CN' => '家居 & 庭院', :de => 'Haushalt & Garten'}
)

category_home_accessories = Category.create!(
    :name => 'Home Accessories',
    :code => 'L2-273',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '家具饰品', :de => 'Haushaltsartikel'}
)

Category.create!(
    :name => 'Kitchen Accessories',
    :code => 'L2-275',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '厨房用品', :de => 'Küchenaccessoires'}
)

Category.create!(
    :name => 'Lighting',
    :code => 'L2-173',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '照明', :de => 'Beleuchtungen'}
)


Category.create!(
    :name => 'Furniture & Baby Furniture',
    :code => 'L2-388',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '家具 & 婴儿家具', :de => 'Möbel & Baby-Einrichtungen'}
)


Category.create!(
    :name => 'Kitchenware & Tableware',
    :code => 'L2-639',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '厨房用具 & 餐具', :de => 'Küchengeräte & Geschirre'}
)

Category.create!(
    :name => 'Cutlery & Kitchen Utensils',
    :code => 'L2-640',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '刀具', :de => 'Bestecke'}
)


Category.create!(
    :name => 'Cookware',
    :code => 'L2-641',
    :parent => category_home_garden,
    :name_locales => { :'zh-CN' => '炊具', :de => 'Kochgeschirre'}
)

#
# jewellery & watches category - level 1
#
category_jewellery_watches = Category.create!(
    :name => 'Jewellery & Watches',
    :code => 'L1-321',
    :cssc => 'fa-clock-o',
    :parent => category_fashion,
    :name_locales => { :'zh-CN' => '首饰 & 表', :de => 'Schmuck & Uhren'}
)

Category.create!(
    :name => 'Jewellery of Precious Metals',
    :code => 'L2-322',
    :parent => category_jewellery_watches,
    :name_locales => { :'zh-CN' => '金银首饰', :de => 'Edelmetallschmuck'}
)

Category.create!(
    :name => 'Pearls, Precious & Semiprecious Stones',
    :code => 'L2-325',
    :parent => category_jewellery_watches,
    :name_locales => { :'zh-CN' => '珍珠 & 宝石首饰', :de => 'Perlenschmuck & Edelsteinschmuck'}
)

Category.create!(
    :name => 'Clocks',
    :code => 'L2-561',
    :parent => category_jewellery_watches,
    :status => false
)

Category.create!(
    :name => 'Watch & Clock Parts',
    :code => 'L2-563',
    :parent => category_jewellery_watches,
    :name_locales => { :'zh-CN' => '手表 & 钟', :de => 'Armbanduhren & Uhrenteile'}
)

#
# toys & games category - level 1
#
category_toys_games = Category.create!(
    :name => 'Toys & Games',
    :code => 'L1-329',
    :cssc => ' fa-gamepad',
    :parent => category_toys_home,
    :name_locales => { :'zh-CN' => '玩具 & 游戏', :de => 'Spielzeuge & Spiele'}
)

Category.create!(
    :name => 'Figures & Dolls',
    :code => 'L2-220',
    :parent => category_toys_games,
    :name_locales => { :'zh-CN' => '玩具娃娃', :de => 'Figuren & Puppen'}
)

Category.create!(
    :name => 'Model Vehicles, Slot Racing & Radio-Controlled Toys',
    :code => 'L2-227',
    :parent => category_toys_games,
    :name_locales => { :'zh-CN' => '模型 & 遥控玩具', :de => 'Modelfahrzeuge & Ferngesteuerte Spielzeuge'}
)

Category.create!(
    :name => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys',
    :code => 'L2-664',
    :parent => category_toys_games,
    :name_locales => { :'zh-CN' => '三轮车 & 脚蹬车', :de => 'Dreiräder & Roller'}
)

Category.create!(
    :name => 'Other Toys & Games',
    :code => 'L2-229',
    :parent => category_toys_games,
    :name_locales => { :'zh-CN' => '其他玩具', :de => 'Andere Spielzeuge'}
)

#
# food & drink category - level 1
#
category_food_drinks = Category.create!(
    :name => 'Food & Drinks',
    :code => 'L1-578',
    :cssc => 'fa-cutlery',
    :parent => category_food,
    :name_locales => { :'zh-CN' => '食品和饮料', :de => 'Lebensmittel  & Getränke'}
)

Category.create!(
    :name => 'Non-alcoholic Beverages',
    :code => 'L2-97',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '软饮料', :de => 'alkoholfreie Getränke'}
)

Category.create!(
    :name => 'Spirits',
    :code => 'L2-587',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '烈酒', :de => 'Spirituosen'}
)

Category.create!(
    :name => 'Sweets, Snacks & Confectionery',
    :code => 'L2-633',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '糖果 & 零食', :de => 'Süßigkeiten & Snacks'}
)

Category.create!(
    :name => 'Fruit, Nuts, Seeds & Vegetables',
    :code => 'L2-635',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '干果 & 坚果', :de => 'Nüsse & Früchte'}
)

Category.create!(
    :name => 'Jams, Honey & Spreads',
    :code => 'L2-665',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '果酱 & 蜂蜜 ', :de => 'Konfitüren & Honige'}
)

Category.create!(
    :name => 'Oils, Herbs & Spices',
    :code => 'L2-666',
    :parent => category_food_drinks,
    :name_locales => { :'zh-CN' => '烹饪色拉油 & 佐料', :de => 'Öle, Kräuter & Gewürze'}
)

#
# category shoes & footwear - level 1
#
category_shoes_footwear = Category.create!(
    :name => 'Shoes & Footwear',
    :code => 'L1-661',
    :cssc => 'fa-gift',
    :parent => category_fashion,
    :status => false
)

Category.create!(
    :name => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins',
    :code => 'L2-543',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins',
    :code => 'L2-602',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins',
    :code => 'L2-603',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Men | house slippers',
    :code => 'L2-613',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Women | house slippers',
    :code => 'L2-616',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Boots & High Tops',
    :code => 'L2-619',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Children | House Slippers',
    :code => 'L2-620',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Children | Sandals & Flip Flops',
    :code => 'L2-621',
    :parent => category_shoes_footwear,
    :status => false
)

Category.create!(
    :name => 'Other Footwear',
    :code => 'L2-600',
    :parent => category_shoes_footwear,
    :status => false
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

User.where(:email => 'skopkeeper@hotmail.com').all.delete;
Shop.where(:name => /.*Herz-Buffet.*/i).all.delete;
Product.where(:name => /.*10 Blatt Seidenpapier ♥ Panda ♥.*/).all.delete;
Product.where({:name => /.*熊猫壁纸.*/i}).all.delete;

shopkeeper = User.where(:email => 'shopkeeper01@hotmail.com').first
shopkeeper.role = :shopkeeper
shopkeeper.save!

shop = Shop.create!(
    :name => 'Herz-Buffet 01',
    :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
    :logo => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
    :banner => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg'),
    :min_total => 20,
    :shopkeeper => shopkeeper
);

product = Product.new(
    :name => '10 Blatt Seidenpapier ♥ Panda ♥ 01',
    :desc => %Q{
  ♥ 10 Bögen Seidenpapier
  ♥ Panda
  ♥ Größe je Bogen: 50 x 70cm
  ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
  ♥ Das Papier wird auf 18x25cm gefaltet versendet
  },
    :cover => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img0 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img1 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img2 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img3 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :brand => 'Herz-Buffet',
    :tags => ['壁纸', '熊猫', 'buffet'],
    :shop => shop
)

v1 = VariantOption.new(:name => :size, :product => product, :name_locales => { :'zh-CN' => '尺寸', :de => 'Größe'})
v1_o1 = VariantOption.new(:parent => v1, :name => :small, :name_locales => { :'zh-CN' => '小号', :de => 'klein'})
v1_o2 = VariantOption.new(:parent => v1, :name => :medium, :name_locales => { :'zh-CN' => '中号', :de => 'mittlere'})
v1_o3 = VariantOption.new(:parent => v1, :name => :large, :name_locales => { :'zh-CN' => '大号', :de => 'groß'})

v2 = VariantOption.new(:name => :color, :product => product,  :name_locales => { :'zh-CN' => '颜色', :de => 'Farbe'})
v2_o1 = VariantOption.new(:parent => v2, :name => :red, :name_locales => { :'zh-CN' => '红色', :de => 'rot'})
v2_o2 = VariantOption.new(:parent => v2, :name => :blue, :name_locales => { :'zh-CN' => '蓝色', :de => 'blau'})
v2_o3 = VariantOption.new(:parent => v2, :name => :gold, :name_locales => { :'zh-CN' => '金色', :de => 'gold'})

s1 = Sku.new(:price => 10, :product => product, :quantity => 5)
s1.option_ids << v1_o1.id.to_s
s1.option_ids << v2_o1.id.to_s
s1.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.save!

s2 = Sku.new(:price => 10, :product => product, :quantity => 4)
s2.option_ids << v1_o2.id.to_s
s2.option_ids << v2_o1.id.to_s
s2.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.save!

s3 = Sku.new(:price => 20, :product => product, :limited => true, :quantity => 3)
s3.option_ids << v1_o3.id.to_s
s3.option_ids << v2_o3.id.to_s
s3.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.save!

product.categories << category_home_accessories

shop.products << product
shop.save!

shopkeeper = User.where(:email => 'shopkeeper02@hotmail.com').first
shopkeeper.role = :shopkeeper
shopkeeper.save!

shop = Shop.create!(
    :name => 'Herz-Buffet 02',
    :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
    :logo => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
    :banner => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg'),
    :min_total => 20,
    :shopkeeper => shopkeeper
);

product = Product.new(
    :name => '10 Blatt Seidenpapier ♥ Panda ♥ 02',
    :desc => %Q{
  ♥ 10 Bögen Seidenpapier
  ♥ Panda
  ♥ Größe je Bogen: 50 x 70cm
  ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
  ♥ Das Papier wird auf 18x25cm gefaltet versendet
  },
    :cover => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img0 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img1 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img2 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img3 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :brand => 'Herz-Buffet',
    :tags => ['壁纸', '熊猫', 'buffet'],
    :shop => shop
)

v1 = VariantOption.new(:name => :size, :product => product, :name_locales => { :'zh-CN' => '尺寸', :de => 'Größe'})
v1_o1 = VariantOption.new(:parent => v1, :name => :small, :name_locales => { :'zh-CN' => '小号', :de => 'klein'})
v1_o2 = VariantOption.new(:parent => v1, :name => :medium, :name_locales => { :'zh-CN' => '中号', :de => 'mittlere'})
v1_o3 = VariantOption.new(:parent => v1, :name => :large, :name_locales => { :'zh-CN' => '大号', :de => 'groß'})

v2 = VariantOption.new(:name => :color, :product => product,  :name_locales => { :'zh-CN' => '颜色', :de => 'Farbe'})
v2_o1 = VariantOption.new(:parent => v2, :name => :red, :name_locales => { :'zh-CN' => '红色', :de => 'rot'})
v2_o2 = VariantOption.new(:parent => v2, :name => :blue, :name_locales => { :'zh-CN' => '蓝色', :de => 'blau'})
v2_o3 = VariantOption.new(:parent => v2, :name => :gold, :name_locales => { :'zh-CN' => '金色', :de => 'gold'})

s1 = Sku.new(:price => 10, :product => product, :quantity => 5)
s1.option_ids << v1_o1.id.to_s
s1.option_ids << v2_o1.id.to_s
s1.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s1.save!

s2 = Sku.new(:price => 10, :product => product, :quantity => 4)
s2.option_ids << v1_o2.id.to_s
s2.option_ids << v2_o1.id.to_s
s2.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s2.save!

s3 = Sku.new(:price => 20, :product => product, :limited => true, :quantity => 3)
s3.option_ids << v1_o3.id.to_s
s3.option_ids << v2_o3.id.to_s
s3.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
s3.save!

product.categories << category_home_accessories

shop.products << product
shop.save!

Rails.cache.clear

