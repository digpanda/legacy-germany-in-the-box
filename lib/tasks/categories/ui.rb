Category.all.delete

#
# root category - level 0
#
category_cosmetics_care = Category.create!(
    :name_translations => {:en => 'Cosmetics', :'zh-CN' => '美妆', :de => 'Kosmetik & Pflege'},
    :slug => 'cosmetics'
)

category_medicine_care = Category.create!(
    :name_translations => {:en => 'Medicine', :'zh-CN' => '药品保健', :de => 'Gesundheit & Medizin'},
    :slug => 'medicine'
)

category_food_drinks = Category.create!(
    :name_translations => {:en => 'Food', :'zh-CN' => '食品和饮料', :de => 'Lebensmittel  & Getränke'},
    :slug => 'food'
)

category_fashion = Category.create!(
    :name_translations => {:en => 'Fashion', :'zh-CN' => '时尚', :de => 'Mode'},
    :slug => 'fashion'
)


#
# Cosmetics & Care - level 1
#
=begin
Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Bath & Shower', :'zh-CN' => '沐浴', :de => 'Bad & Dusche'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Hair Care', :'zh-CN' => '护发', :de => 'Haarpflege'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '护肤 & 化妆品', :de => 'Hautpflege '}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '儿童护理清洁', :de => 'Kinderpflege'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '身体护理', :de => 'Körperpflege'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '化妆品', :de => 'Kosmetik'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '天然化妆品', :de => 'Naturkosmetik'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '孕妇身体护理', :de => 'Schwangerpflege'}
)

Category.create!(
    :parent => category_cosmetics_care,
    :name_translations => {:en => 'Massage & Orthopaedic', :'zh-CN' => '按摩用品', :de => 'Massage & Orthopädie'}
)

#
# Medicine & Care - level 1
#

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '女性护理用品', :de => 'Hygiene & Sanitäre Produkte'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '儿童保健', :de => 'Kinder'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '医疗器材', :de => 'Medizinische Geräte'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '天然保健品', :de => 'Naturheilmittel'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '母婴保健', :de => 'Schwangerschaft & Baby'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Health Care', :'zh-CN' => '伤口护理', :de => 'Wundversorgung'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '心血管血压', :de => 'Kreislauf & Herz'}
)


Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '非处方药', :de => 'Rezeptfreies Medikament'}
)

Category.create!(
    :parent => category_medicine_care,
    :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '保健品', :de => 'Vitamine & Nahrungsergänzung'}
)

#
# bags & accessories category - level 1
#
category_bags_accessories = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Bags & Accessories', :'zh-CN' => '包包 & 配饰', :de => 'Taschen & Accessoires'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Belts', :'zh-CN' => '腰带', :de => 'Gürtel'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Bag Accessories'},
    :status => false
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Gloves & Ear Muffs'},
    :status => false
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Sunglasses', :'zh-CN' => '太阳镜', :de => 'Sonnenbrillen'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Briefcases, School Satchels & Messenger Bags'},
    :status => false
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Handbags, Clutches & Shoulder Bags', :'zh-CN' => '手包 & 背包', :de => 'Handtaschen & Umhängetaschen'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Purses, Pouches & Wallets', :'zh-CN' => '钱包 & 小包', :de => 'Portemonnaies & Pouches'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags'},
    :status => false
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Scarves, Shawls & Veils', :'zh-CN' => '围巾 & 披肩', :de => 'Tücher & Schleier'}
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Key Rings & Moneyclips'},
    :status => false
)


Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Wristbands'},
    :status => false
)

Category.create!(
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Other Accessories', :'zh-CN' => '其他配饰', :de => 'Andere Accessoires'}
)


#
# clothes for men category - level 1
#
category_clothes_for_men = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Clothes for Men', :'zh-CN' => '男性时尚', :de => 'Herrenmode'},
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair'},
    :status => false
)


Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Suits, Suit Jackets & Blazers'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'T-Shirts, Shirts & Polos', :'zh-CN' => '体恤 & Polo衫', :de => 'T-Shirts & Poloshirts'}
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Trousers, Shorts & Jeans'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)


#
# clothes for women category - level 1
#
category_clothes_for_women = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Clothes for Women', :'zh-CN' => '女性时尚', :de => 'Damenmode'}
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Body Shapers'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear & Woven Other Textile Materials'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Dresses', :'zh-CN' => '连衣裙', :de => 'Kleider'}
)


Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Lingerie'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Skirts, Skorts & Culottes', :'zh-CN' => '短裙 & 裤裙', :de => 'Röcke & Hosenröcke'}
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Suits, Suit Jackets & Blazers', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Jackets'}
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Trousers, Shorts & Jeans', :'zh-CN' => '长短裤 & 牛仔', :de => 'Hosen & Kurzhosen'}
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Wedding & Prom Dresses'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear & Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Other Garments'},
    :status => false
)

#
# clothes for babies & essentials - level 1
#
category_clothes_for_babies_essentials = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Clothes for Babies & Essentials', :'zh-CN' => '婴儿衣装 & 用品', :de => 'Babybekleidung & Babybedarf'}
)

Category.create!(
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Clothes of cotton', :'zh-CN' => '婴儿棉质衣装', :de => 'Babybekleidungen'}
)

Category.create!(
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Clothes of Synthetic Fibre'},
    :status => false
)


Category.create!(
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Essentials', :'zh-CN' => '婴儿用品', :de => 'Babybedarf'}
)

#
# clothes for children - level 1
#
category_clothes_for_children = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Clothes for Children', :'zh-CN' => '儿童时尚', :de => 'Kindermode'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Outerwear', :'zh-CN' => '外衣', :de => 'Oberkleidungen'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Suits, Jackets & Dresses', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Kleider'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Sweaters & Sweatshirts', :'zh-CN' => '毛衣 & 运动衫', :de => 'Pullis & Sweatshirts'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'T-Shirts, Shirts & Blouses', :'zh-CN' => '体恤衫 & 女衬衫', :de => 'T-Shirts & Blusen'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Trousers, Jeans & Skirts', :'zh-CN' => '长裤 & 裙子', :de => 'Hosen & Röcke'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Underwear & Sleepwear', :'zh-CN' => '内衣 & 睡衣', :de => 'Unterwäschen & Nachtwäsche'}
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Used & Worn Clothing'},
    :status => false
)

Category.create!(
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Socks & Tights', :'zh-CN' => '袜子 & 裤袜', :de => 'Socken & Strumpfhosen'}
)


#
# health & beauty category - level 1
#
category_health_beauty = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Health & Beauty', :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege'}
)

Category.create!(
    :parent => category_health_beauty,
    :name_translations => {:en => 'Fragrances'},
    :status => false
)

Category.create!(
    :parent => category_health_beauty,
    :name_translations => {:en => 'Supplements', :'zh-CN' => '增补品', :de => 'Ergänzungen'}
)

#
# home & garden category - level 1
#
category_home_garden = Category.create!(
    :parent => category_toys_home,
    :name_translations => {:en => 'Home & Garden', :'zh-CN' => '家居 & 庭院', :de => 'Haushalt & Garten'}
)

category_home_accessories = Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Home Accessories', :'zh-CN' => '家具饰品', :de => 'Haushaltsartikel'}
)

Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Kitchen Accessories', :'zh-CN' => '厨房用品', :de => 'Küchenaccessoires'}
)

Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Lighting', :'zh-CN' => '照明', :de => 'Beleuchtungen'}
)


Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Furniture & Baby Furniture', :'zh-CN' => '家具 & 婴儿家具', :de => 'Möbel & Baby-Einrichtungen'}
)


Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Kitchenware & Tableware', :'zh-CN' => '厨房用具 & 餐具', :de => 'Küchengeräte & Geschirre'}
)

Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Cutlery & Kitchen Utensils', :'zh-CN' => '刀具', :de => 'Bestecke'}
)


Category.create!(
    :parent => category_home_garden,
    :name_translations => {:en => 'Cookware', :'zh-CN' => '炊具', :de => 'Kochgeschirre'}
)

#
# jewellery & watches category - level 1
#
category_jewellery_watches = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Jewellery & Watches', :'zh-CN' => '首饰 & 表', :de => 'Schmuck & Uhren'}
)

Category.create!(
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Jewellery of Precious Metals', :'zh-CN' => '金银首饰', :de => 'Edelmetallschmuck'}
)

Category.create!(
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Pearls, Precious & Semiprecious Stones', :'zh-CN' => '珍珠 & 宝石首饰', :de => 'Perlenschmuck & Edelsteinschmuck'}
)

Category.create!(
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Clocks'},
    :status => false
)

Category.create!(
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Watch & Clock Parts', :'zh-CN' => '手表 & 钟表及部件', :de => 'Armbanduhren & Uhrenteile'}
)

#
# toys & games category - level 1
#
category_toys_games = Category.create!(
    :parent => category_toys_home,
    :name_translations => {:en => 'Toys & Games', :'zh-CN' => '玩具 & 游戏', :de => 'Spielzeuge & Spiele'}
)

Category.create!(
    :parent => category_toys_games,
    :name_translations => {:en => 'Figures & Dolls', :'zh-CN' => '玩具娃娃', :de => 'Figuren & Puppen'}
)

Category.create!(
    :parent => category_toys_games,
    :name_translations => {:en => 'Model Vehicles, Slot Racing & Radio-Controlled Toys', :'zh-CN' => '模型 & 遥控玩具', :de => 'Modelfahrzeuge & Ferngesteuerte Spielzeuge'}
)

Category.create!(
    :parent => category_toys_games,
    :name_translations => {:en => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys', :'zh-CN' => '三轮车 & 脚蹬车', :de => 'Dreiräder & Roller'}
)

Category.create!(
    :parent => category_toys_games,
    :name_translations => {:en => 'Other Toys & Games', :'zh-CN' => '其他玩具', :de => 'Andere Spielzeuge'}
)

#
# food & drink category - level 1
#
Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'wine < 15%vol: red - produced in E.U.', :'zh-CN' => '红葡萄酒', :de => 'Rotwein'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'champagne & other sparkling wines', :'zh-CN' => '气泡酒', :de => 'Sekt'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'champagne & other sparkling wines', :'zh-CN' => '白葡萄酒', :de => 'Weißwein'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Non-alcoholic Beverages', :'zh-CN' => '软饮料', :de => 'Alkoholfreie Getränke'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Spirits', :'zh-CN' => '烈酒', :de => 'Spirituosen'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Sweets, Snacks & Confectionery', :'zh-CN' => '糖果 & 零食', :de => 'Süßigkeiten & Snacks'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Fruit, Nuts, Seeds & Vegetables', :'zh-CN' => '干果 & 坚果', :de => 'Nüsse & Früchte'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Jams, Honey & Spreads', :'zh-CN' => '果酱 & 蜂蜜 ', :de => 'Konfitüren & Honige'}
)

Category.create!(
    :parent => category_food_drinks,
    :name_translations => {:en => 'Oils, Herbs & Spices', :'zh-CN' => '烹饪色拉油 & 佐料', :de => 'Öle, Kräuter & Gewürze'}
)

#
# category shoes & footwear - level 1
#
category_shoes_footwear = Category.create!(
    :parent => category_fashion,
    :name_translations => {:en => 'Shoes & Footwear'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Men | house slippers'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Women | house slippers'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Boots & High Tops'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Children | House Slippers'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Children | Sandals & Flip Flops'},
    :status => false
)

Category.create!(
    :parent => category_shoes_footwear,
    :name_translations => {:en => 'Other Footwear'},
    :status => false
)
=end

Rails.cache.clear