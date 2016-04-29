#Product.all.delete;
#Category.all.delete;

#
# root category - level 0
#
category_cosmetics_care = Category.create!(
    :name => {:en => 'Cosmetics & Care', :'zh-CN' => '美妆', :de => 'Kosmetik & Pflege'}
)

category_medicine_care = Category.create!(
    :name => {:en => 'Medicine & Care', :'zh-CN' => '药品保健', :de => 'Gesundheit & Medizin'}
)

category_food_drinks = Category.create!(
    :name => {:en => 'Food & Drinks', :'zh-CN' => '食品和饮料', :de => 'Lebensmittel  & Getränke'}
)

category_fashion = Category.create!(
    :name => {:en => 'Fashion', :'zh-CN' => '时尚', :de => 'Mode'}
)

category_toys_home = Category.create!(
    :name => {:en => 'Toys & Home', :'zh-CN' => '玩具家居', :de => 'Spielzeuge & Heim'}
)

#
# Cosmetics & Care - level 1
#
Category.create!(
    :code => 'L2-278',
    :parent => category_cosmetics_care,
    :name => {:en => 'Bath & Shower', :'zh-CN' => '沐浴', :de => 'Bad & Dusche'}
)

Category.create!(
    :code => 'L2-92',
    :parent => category_cosmetics_care,
    :name => {:en => 'Hair Care', :'zh-CN' => '护发', :de => 'Haarpflege'}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '护肤 & 化妆品', :de => 'Hautpflege '}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '儿童护理清洁', :de => 'Kinderpflege'}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '身体护理', :de => 'Körperpflege'}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '化妆品', :de => 'Kosmetik'}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '天然化妆品', :de => 'Naturkosmetik'}
)

Category.create!(
    :code => 'L2-94',
    :parent => category_cosmetics_care,
    :name => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '孕妇身体护理', :de => 'Schwangerpflege'}
)

Category.create!(
    :code => 'L2-662',
    :parent => category_cosmetics_care,
    :name => {:en => 'Massage & Orthopaedic', :'zh-CN' => '按摩用品', :de => 'Massage & Orthopädie'}
)

#
# Medicine & Care - level 1
#

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '女性护理用品', :de => 'Hygiene & Sanitäre Produkte'}
)

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '儿童保健', :de => 'Kinder'}
)

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '医疗器材', :de => 'Medizinische Geräte'}
)

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '天然保健品', :de => 'Naturheilmittel'}
)

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '母婴保健', :de => 'Schwangerschaft & Baby'}
)

Category.create!(
    :code => 'L2-93',
    :parent => category_medicine_care,
    :name => {:en => 'Health Care', :'zh-CN' => '伤口护理', :de => 'Wundversorgung'}
)

Category.create!(
    :code => 'L2-276',
    :parent => category_medicine_care,
    :name => {:en => 'Medicine & Vitamins', :'zh-CN' => '心血管血压', :de => 'Kreislauf & Herz'}
)


Category.create!(
    :code => 'L2-276',
    :parent => category_medicine_care,
    :name => {:en => 'Medicine & Vitamins', :'zh-CN' => '非处方药', :de => 'Rezeptfreies Medikament'}
)

Category.create!(
    :code => 'L2-276',
    :parent => category_medicine_care,
    :name => {:en => 'Medicine & Vitamins', :'zh-CN' => '保健品', :de => 'Vitamine & Nahrungsergänzung'}
)

#
# bags & accessories category - level 1
#
category_bags_accessories = Category.create!(
    :code => 'L1-1',
    :parent => category_fashion,
    :name => {:en => 'Bags & Accessories', :'zh-CN' => '包包 & 配饰', :de => 'Taschen & Accessoires'}
)

Category.create!(
    :code => 'L2-251',
    :parent => category_bags_accessories,
    :name => {:en => 'Belts', :'zh-CN' => '腰带', :de => 'Gürtel'}
)

Category.create!(
    :code => 'L2-291',
    :parent => category_bags_accessories,
    :name => {:en => 'Bag Accessories'},
    :status => false
)

Category.create!(
    :code => 'L2-404',
    :parent => category_bags_accessories,
    :name => {:en => 'Gloves & Ear Muffs'},
    :status => false
)

Category.create!(
    :code => 'L2-406',
    :parent => category_bags_accessories,
    :name => {:en => 'Sunglasses', :'zh-CN' => '太阳镜', :de => 'Sonnenbrillen'}
)

Category.create!(
    :code => 'L2-624',
    :parent => category_bags_accessories,
    :name => {:en => 'Briefcases, School Satchels & Messenger Bags'},
    :status => false
)

Category.create!(
    :code => 'L2-626',
    :parent => category_bags_accessories,
    :name => {:en => 'Handbags, Clutches & Shoulder Bags', :'zh-CN' => '手包 & 背包', :de => 'Handtaschen & Umhängetaschen'}
)

Category.create!(
    :code => 'L2-627',
    :parent => category_bags_accessories,
    :name => {:en => 'Purses, Pouches & Wallets', :'zh-CN' => '钱包 & 小包', :de => 'Portemonnaies & Pouches'}
)

Category.create!(
    :code => 'L2-628',
    :parent => category_bags_accessories,
    :name => {:en => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags'},
    :status => false
)

Category.create!(
    :code => 'L2-645',
    :parent => category_bags_accessories,
    :name => {:en => 'Scarves, Shawls & Veils', :'zh-CN' => '围巾 & 披肩', :de => 'Tücher & Schleier'}
)

Category.create!(
    :code => 'L2-646',
    :parent => category_bags_accessories,
    :name => {:en => 'Key Rings & Moneyclips'},
    :status => false
)


Category.create!(
    :code => 'L2-649',
    :parent => category_bags_accessories,
    :name => {:en => 'Wristbands'},
    :status => false
)

Category.create!(
    :code => 'L2-244',
    :parent => category_bags_accessories,
    :name => {:en => 'Other Accessories', :'zh-CN' => '其他配饰', :de => 'Andere Accessoires'}
)


#
# clothes for men category - level 1
#
category_clothes_for_men = Category.create!(
    :code => 'L1-47',
    :parent => category_fashion,
    :name => {:en => 'Clothes for Men', :'zh-CN' => '男性时尚', :de => 'Herrenmode'},
)

Category.create!(
    :code => 'L2-63',
    :parent => category_clothes_for_men,
    :name => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

Category.create!(
    :code => 'L2-48',
    :parent => category_clothes_for_men,
    :name => {:en => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair'},
    :status => false
)


Category.create!(
    :code => 'L2-50',
    :parent => category_clothes_for_men,
    :name => {:en => 'Suits, Suit Jackets & Blazers'},
    :status => false
)

Category.create!(
    :code => 'L2-53',
    :parent => category_clothes_for_men,
    :name => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :code => 'L2-51',
    :parent => category_clothes_for_men,
    :name => {:en => 'T-Shirts, Shirts & Polos', :'zh-CN' => '体恤 & Polo衫', :de => 'T-Shirts & Poloshirts'}
)

Category.create!(
    :code => 'L2-52',
    :parent => category_clothes_for_men,
    :name => {:en => 'Trousers, Shorts & Jeans'},
    :status => false
)

Category.create!(
    :code => 'L2-596',
    :parent => category_clothes_for_men,
    :name => {:en => 'Outerwear, Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :code => 'L2-669',
    :parent => category_clothes_for_men,
    :name => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)


#
# clothes for women category - level 1
#
category_clothes_for_women = Category.create!(
    :code => 'L1-64',
    :parent => category_fashion,
    :name => {:en => 'Clothes for Women', :'zh-CN' => '女性时尚', :de => 'Damenmode'}
)

Category.create!(
    :code => 'L2-245',
    :parent => category_clothes_for_women,
    :name => {:en => 'Body Shapers'},
    :status => false
)

Category.create!(
    :code => 'L2-66',
    :parent => category_clothes_for_women,
    :name => {:en => 'Outerwear & Woven Other Textile Materials'},
    :status => false
)

Category.create!(
    :code => 'L2-77',
    :parent => category_clothes_for_women,
    :name => {:en => 'Dresses', :'zh-CN' => '连衣裙', :de => 'Kleider'}
)


Category.create!(
    :code => 'L2-80',
    :parent => category_clothes_for_women,
    :name => {:en => 'Lingerie'},
    :status => false
)

Category.create!(
    :code => 'L2-75',
    :parent => category_clothes_for_women,
    :name => {:en => 'Skirts, Skorts & Culottes', :'zh-CN' => '短裙 & 裤裙', :de => 'Röcke & Hosenröcke'}
)

Category.create!(
    :code => 'L2-248',
    :parent => category_clothes_for_women,
    :name => {:en => 'Suits, Suit Jackets & Blazers', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Jackets'}
)

Category.create!(
    :code => 'L2-78',
    :parent => category_clothes_for_women,
    :name => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

Category.create!(
    :code => 'L2-246',
    :parent => category_clothes_for_women,
    :name => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :code => 'L2-79',
    :parent => category_clothes_for_women,
    :name => {:en => 'Trousers, Shorts & Jeans', :'zh-CN' => '长短裤 & 牛仔', :de => 'Hosen & Kurzhosen'}
)

Category.create!(
    :code => 'L2-81',
    :parent => category_clothes_for_women,
    :name => {:en => 'Wedding & Prom Dresses'},
    :status => false
)

Category.create!(
    :code => 'L2-591',
    :parent => category_clothes_for_women,
    :name => {:en => 'Outerwear & Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :code => 'L2-670',
    :parent => category_clothes_for_women,
    :name => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)

Category.create!(
    :code => 'L2-593',
    :parent => category_clothes_for_women,
    :name => {:en => 'Other Garments'},
    :status => false
)

#
# clothes for babies & essentials - level 1
#
category_clothes_for_babies_essentials = Category.create!(
    :code => 'L1-331',
    :parent => category_fashion,
    :name => {:en => 'Clothes for Babies & Essentials', :'zh-CN' => '婴儿衣装 & 用品', :de => 'Babybekleidung & Babybedarf'}
)

Category.create!(
    :code => 'L2-332',
    :parent => category_clothes_for_babies_essentials,
    :name => {:en => 'Baby Clothes of cotton', :'zh-CN' => '婴儿棉质衣装', :de => 'Babybekleidungen'}
)

Category.create!(
    :code => 'L2-334',
    :parent => category_clothes_for_babies_essentials,
    :name => {:en => 'Baby Clothes of Synthetic Fibre'},
    :status => false
)


Category.create!(
    :code => 'L2-356',
    :parent => category_clothes_for_babies_essentials,
    :name => {:en => 'Baby Essentials', :'zh-CN' => '婴儿用品', :de => 'Babybedarf'}
)

#
# clothes for children - level 1
#
category_clothes_for_children = Category.create!(
    :code => 'L1-414',
    :parent => category_fashion,
    :name => {:en => 'Clothes for Children', :'zh-CN' => '儿童时尚', :de => 'Kindermode'}
)

Category.create!(
    :code => 'L2-415',
    :parent => category_clothes_for_children,
    :name => {:en => 'Outerwear', :'zh-CN' => '外衣', :de => 'Oberkleidungen'}
)

Category.create!(
    :code => 'L2-428',
    :parent => category_clothes_for_children,
    :name => {:en => 'Suits, Jackets & Dresses', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Kleider'}
)

Category.create!(
    :code => 'L2-446',
    :parent => category_clothes_for_children,
    :name => {:en => 'Sweaters & Sweatshirts', :'zh-CN' => '毛衣 & 运动衫', :de => 'Pullis & Sweatshirts'}
)

Category.create!(
    :code => 'L2-452',
    :parent => category_clothes_for_children,
    :name => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :code => 'L2-462',
    :parent => category_clothes_for_children,
    :name => {:en => 'T-Shirts, Shirts & Blouses', :'zh-CN' => '体恤衫 & 女衬衫', :de => 'T-Shirts & Blusen'}
)

Category.create!(
    :code => 'L2-474',
    :parent => category_clothes_for_children,
    :name => {:en => 'Trousers, Jeans & Skirts', :'zh-CN' => '长裤 & 裙子', :de => 'Hosen & Röcke'}
)

Category.create!(
    :code => 'L2-522',
    :parent => category_clothes_for_children,
    :name => {:en => 'Underwear & Sleepwear', :'zh-CN' => '内衣 & 睡衣', :de => 'Unterwäschen & Nachtwäsche'}
)

Category.create!(
    :code => 'L2-541',
    :parent => category_clothes_for_children,
    :name => {:en => 'Used & Worn Clothing'},
    :status => false
)

Category.create!(
    :code => 'L2-606',
    :parent => category_clothes_for_children,
    :name => {:en => 'Socks & Tights', :'zh-CN' => '袜子 & 裤袜', :de => 'Socken & Strumpfhosen'}
)


#
# health & beauty category - level 1
#
category_health_beauty = Category.create!(
    :code => 'L1-84',
    :parent => category_fashion,
    :name => {:en => 'Health & Beauty', :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege'}
)

Category.create!(
    :code => 'L2-91',
    :parent => category_health_beauty,
    :name => {:en => 'Fragrances'},
    :status => false
)

Category.create!(
    :code => 'L2-277',
    :parent => category_health_beauty,
    :name => {:en => 'Supplements', :'zh-CN' => '增补品', :de => 'Ergänzungen'}
)

#
# home & garden category - level 1
#
category_home_garden = Category.create!(
    :code => 'L1-150',
    :parent => category_toys_home,
    :name => {:en => 'Home & Garden', :'zh-CN' => '家居 & 庭院', :de => 'Haushalt & Garten'}
)

category_home_accessories = Category.create!(
    :code => 'L2-273',
    :parent => category_home_garden,
    :name => {:en => 'Home Accessories', :'zh-CN' => '家具饰品', :de => 'Haushaltsartikel'}
)

Category.create!(
    :code => 'L2-275',
    :parent => category_home_garden,
    :name => {:en => 'Kitchen Accessories', :'zh-CN' => '厨房用品', :de => 'Küchenaccessoires'}
)

Category.create!(
    :code => 'L2-173',
    :parent => category_home_garden,
    :name => {:en => 'Lighting', :'zh-CN' => '照明', :de => 'Beleuchtungen'}
)


Category.create!(
    :code => 'L2-388',
    :parent => category_home_garden,
    :name => {:en => 'Furniture & Baby Furniture', :'zh-CN' => '家具 & 婴儿家具', :de => 'Möbel & Baby-Einrichtungen'}
)


Category.create!(
    :code => 'L2-639',
    :parent => category_home_garden,
    :name => {:en => 'Kitchenware & Tableware', :'zh-CN' => '厨房用具 & 餐具', :de => 'Küchengeräte & Geschirre'}
)

Category.create!(
    :code => 'L2-640',
    :parent => category_home_garden,
    :name => {:en => 'Cutlery & Kitchen Utensils', :'zh-CN' => '刀具', :de => 'Bestecke'}
)


Category.create!(
    :code => 'L2-641',
    :parent => category_home_garden,
    :name => {:en => 'Cookware', :'zh-CN' => '炊具', :de => 'Kochgeschirre'}
)

#
# jewellery & watches category - level 1
#
category_jewellery_watches = Category.create!(
    :code => 'L1-321',
    :parent => category_fashion,
    :name => {:en => 'Jewellery & Watches', :'zh-CN' => '首饰 & 表', :de => 'Schmuck & Uhren'}
)

Category.create!(
    :code => 'L2-322',
    :parent => category_jewellery_watches,
    :name => {:en => 'Jewellery of Precious Metals', :'zh-CN' => '金银首饰', :de => 'Edelmetallschmuck'}
)

Category.create!(
    :code => 'L2-325',
    :parent => category_jewellery_watches,
    :name => {:en => 'Pearls, Precious & Semiprecious Stones', :'zh-CN' => '珍珠 & 宝石首饰', :de => 'Perlenschmuck & Edelsteinschmuck'}
)

Category.create!(
    :code => 'L2-561',
    :parent => category_jewellery_watches,
    :name => {:en => 'Clocks'},
    :status => false
)

Category.create!(
    :code => 'L2-563',
    :parent => category_jewellery_watches,
    :name => {:en => 'Watch & Clock Parts', :'zh-CN' => '手表 & 钟表及部件', :de => 'Armbanduhren & Uhrenteile'}
)

#
# toys & games category - level 1
#
category_toys_games = Category.create!(
    :code => 'L1-329',
    :parent => category_toys_home,
    :name => {:en => 'Toys & Games', :'zh-CN' => '玩具 & 游戏', :de => 'Spielzeuge & Spiele'}
)

Category.create!(
    :code => 'L2-220',
    :parent => category_toys_games,
    :name => {:en => 'Figures & Dolls', :'zh-CN' => '玩具娃娃', :de => 'Figuren & Puppen'}
)

Category.create!(
    :code => 'L2-227',
    :parent => category_toys_games,
    :name => {:en => 'Model Vehicles, Slot Racing & Radio-Controlled Toys', :'zh-CN' => '模型 & 遥控玩具', :de => 'Modelfahrzeuge & Ferngesteuerte Spielzeuge'}
)

Category.create!(
    :code => 'L2-664',
    :parent => category_toys_games,
    :name => {:en => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys', :'zh-CN' => '三轮车 & 脚蹬车', :de => 'Dreiräder & Roller'}
)

Category.create!(
    :code => 'L2-229',
    :parent => category_toys_games,
    :name => {:en => 'Other Toys & Games', :'zh-CN' => '其他玩具', :de => 'Andere Spielzeuge'}
)

#
# food & drink category - level 1
#
Category.create!(
    :code => 'L2-581',
    :parent => category_food_drinks,
    :name => {:en => 'wine < 15%vol: red - produced in E.U.', :'zh-CN' => '红葡萄酒', :de => 'Rotwein'}
)

Category.create!(
    :code => 'L2-579',
    :parent => category_food_drinks,
    :name => {:en => 'champagne & other sparkling wines', :'zh-CN' => '气泡酒', :de => 'Sekt'}
)

Category.create!(
    :code => 'L2-580',
    :parent => category_food_drinks,
    :name => {:en => 'champagne & other sparkling wines', :'zh-CN' => '白葡萄酒', :de => 'Weißwein'}
)

Category.create!(
    :code => 'L2-97',
    :parent => category_food_drinks,
    :name => {:en => 'Non-alcoholic Beverages', :'zh-CN' => '软饮料', :de => 'Alkoholfreie Getränke'}
)

Category.create!(
    :code => 'L2-587',
    :parent => category_food_drinks,
    :name => {:en => 'Spirits', :'zh-CN' => '烈酒', :de => 'Spirituosen'}
)

Category.create!(
    :code => 'L2-633',
    :parent => category_food_drinks,
    :name => {:en => 'Sweets, Snacks & Confectionery', :'zh-CN' => '糖果 & 零食', :de => 'Süßigkeiten & Snacks'}
)

Category.create!(
    :code => 'L2-635',
    :parent => category_food_drinks,
    :name => {:en => 'Fruit, Nuts, Seeds & Vegetables', :'zh-CN' => '干果 & 坚果', :de => 'Nüsse & Früchte'}
)

Category.create!(
    :code => 'L2-665',
    :parent => category_food_drinks,
    :name => {:en => 'Jams, Honey & Spreads', :'zh-CN' => '果酱 & 蜂蜜 ', :de => 'Konfitüren & Honige'}
)

Category.create!(
    :code => 'L2-666',
    :parent => category_food_drinks,
    :name => {:en => 'Oils, Herbs & Spices', :'zh-CN' => '烹饪色拉油 & 佐料', :de => 'Öle, Kräuter & Gewürze'}
)

#
# category shoes & footwear - level 1
#
category_shoes_footwear = Category.create!(
    :code => 'L1-661',
    :parent => category_fashion,
    :name => {:en => 'Shoes & Footwear'},
    :status => false
)

Category.create!(
    :code => 'L2-543',
    :parent => category_shoes_footwear,
    :name => {:en => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins'},
    :status => false
)

Category.create!(
    :code => 'L2-602',
    :parent => category_shoes_footwear,
    :name => {:en => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins'},
    :status => false
)

Category.create!(
    :code => 'L2-603',
    :parent => category_shoes_footwear,
    :name => {:en => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins'},
    :status => false
)

Category.create!(
    :code => 'L2-613',
    :parent => category_shoes_footwear,
    :name => {:en => 'Men | house slippers'},
    :status => false
)

Category.create!(
    :code => 'L2-616',
    :parent => category_shoes_footwear,
    :name => {:en => 'Women | house slippers'},
    :status => false
)

Category.create!(
    :code => 'L2-619',
    :parent => category_shoes_footwear,
    :name => {:en => 'Boots & High Tops'},
    :status => false
)

Category.create!(
    :code => 'L2-620',
    :parent => category_shoes_footwear,
    :name => {:en => 'Children | House Slippers'},
    :status => false
)

Category.create!(
    :code => 'L2-621',
    :parent => category_shoes_footwear,
    :name => {:en => 'Children | Sandals & Flip Flops'},
    :status => false
)

Category.create!(
    :code => 'L2-600',
    :parent => category_shoes_footwear,
    :name => {:en => 'Other Footwear'},
    :status => false
)

