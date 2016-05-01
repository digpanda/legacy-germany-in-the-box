namespace :achat do

  desc "create categories data"
  task categories: :environment do
    #
    # root category - level 0
    #
    category_cosmetics_care = Category.create!(
        :name_translations => {:en => 'Cosmetics & Care', :'zh-CN' => '美妆', :de => 'Kosmetik & Pflege'}
    )

    category_medicine_care = Category.create!(
        :name_translations => {:en => 'Medicine & Care', :'zh-CN' => '药品保健', :de => 'Gesundheit & Medizin'}
    )

    category_food_drinks = Category.create!(
        :name_translations => {:en => 'Food & Drinks', :'zh-CN' => '食品和饮料', :de => 'Lebensmittel  & Getränke'}
    )

    category_fashion = Category.create!(
        :name_translations => {:en => 'Fashion', :'zh-CN' => '时尚', :de => 'Mode'}
    )

    category_toys_home = Category.create!(
        :name_translations => {:en => 'Toys & Home', :'zh-CN' => '玩具家居', :de => 'Spielzeuge & Heim'}
    )

    #
    # Cosmetics & Care - level 1
    #
    Category.create!(
        :code => 'L2-278',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Bath & Shower', :'zh-CN' => '沐浴', :de => 'Bad & Dusche'}
    )

    Category.create!(
        :code => 'L2-92',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Hair Care', :'zh-CN' => '护发', :de => 'Haarpflege'}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '护肤 & 化妆品', :de => 'Hautpflege '}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '儿童护理清洁', :de => 'Kinderpflege'}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '身体护理', :de => 'Körperpflege'}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '化妆品', :de => 'Kosmetik'}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '天然化妆品', :de => 'Naturkosmetik'}
    )

    Category.create!(
        :code => 'L2-94',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '孕妇身体护理', :de => 'Schwangerpflege'}
    )

    Category.create!(
        :code => 'L2-662',
        :parent => category_cosmetics_care,
        :name_translations => {:en => 'Massage & Orthopaedic', :'zh-CN' => '按摩用品', :de => 'Massage & Orthopädie'}
    )

    #
    # Medicine & Care - level 1
    #

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '女性护理用品', :de => 'Hygiene & Sanitäre Produkte'}
    )

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '儿童保健', :de => 'Kinder'}
    )

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '医疗器材', :de => 'Medizinische Geräte'}
    )

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '天然保健品', :de => 'Naturheilmittel'}
    )

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '母婴保健', :de => 'Schwangerschaft & Baby'}
    )

    Category.create!(
        :code => 'L2-93',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Health Care', :'zh-CN' => '伤口护理', :de => 'Wundversorgung'}
    )

    Category.create!(
        :code => 'L2-276',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '心血管血压', :de => 'Kreislauf & Herz'}
    )


    Category.create!(
        :code => 'L2-276',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '非处方药', :de => 'Rezeptfreies Medikament'}
    )

    Category.create!(
        :code => 'L2-276',
        :parent => category_medicine_care,
        :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '保健品', :de => 'Vitamine & Nahrungsergänzung'}
    )

    #
    # bags & accessories category - level 1
    #
    category_bags_accessories = Category.create!(
        :code => 'L1-1',
        :parent => category_fashion,
        :name_translations => {:en => 'Bags & Accessories', :'zh-CN' => '包包 & 配饰', :de => 'Taschen & Accessoires'}
    )

    Category.create!(
        :code => 'L2-251',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Belts', :'zh-CN' => '腰带', :de => 'Gürtel'}
    )

    Category.create!(
        :code => 'L2-291',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Bag Accessories'},
        :status => false
    )

    Category.create!(
        :code => 'L2-404',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Gloves & Ear Muffs'},
        :status => false
    )

    Category.create!(
        :code => 'L2-406',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Sunglasses', :'zh-CN' => '太阳镜', :de => 'Sonnenbrillen'}
    )

    Category.create!(
        :code => 'L2-624',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Briefcases, School Satchels & Messenger Bags'},
        :status => false
    )

    Category.create!(
        :code => 'L2-626',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Handbags, Clutches & Shoulder Bags', :'zh-CN' => '手包 & 背包', :de => 'Handtaschen & Umhängetaschen'}
    )

    Category.create!(
        :code => 'L2-627',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Purses, Pouches & Wallets', :'zh-CN' => '钱包 & 小包', :de => 'Portemonnaies & Pouches'}
    )

    Category.create!(
        :code => 'L2-628',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags'},
        :status => false
    )

    Category.create!(
        :code => 'L2-645',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Scarves, Shawls & Veils', :'zh-CN' => '围巾 & 披肩', :de => 'Tücher & Schleier'}
    )

    Category.create!(
        :code => 'L2-646',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Key Rings & Moneyclips'},
        :status => false
    )


    Category.create!(
        :code => 'L2-649',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Wristbands'},
        :status => false
    )

    Category.create!(
        :code => 'L2-244',
        :parent => category_bags_accessories,
        :name_translations => {:en => 'Other Accessories', :'zh-CN' => '其他配饰', :de => 'Andere Accessoires'}
    )


    #
    # clothes for men category - level 1
    #
    category_clothes_for_men = Category.create!(
        :code => 'L1-47',
        :parent => category_fashion,
        :name_translations => {:en => 'Clothes for Men', :'zh-CN' => '男性时尚', :de => 'Herrenmode'},
    )

    Category.create!(
        :code => 'L2-63',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Sweaters & Sweatshirts'},
        :status => false
    )

    Category.create!(
        :code => 'L2-48',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair'},
        :status => false
    )


    Category.create!(
        :code => 'L2-50',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Suits, Suit Jackets & Blazers'},
        :status => false
    )

    Category.create!(
        :code => 'L2-53',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Swimwear & Leisurewear'},
        :status => false
    )

    Category.create!(
        :code => 'L2-51',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'T-Shirts, Shirts & Polos', :'zh-CN' => '体恤 & Polo衫', :de => 'T-Shirts & Poloshirts'}
    )

    Category.create!(
        :code => 'L2-52',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Trousers, Shorts & Jeans'},
        :status => false
    )

    Category.create!(
        :code => 'L2-596',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Outerwear, Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
    )

    Category.create!(
        :code => 'L2-669',
        :parent => category_clothes_for_men,
        :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
        :status => false
    )


    #
    # clothes for women category - level 1
    #
    category_clothes_for_women = Category.create!(
        :code => 'L1-64',
        :parent => category_fashion,
        :name_translations => {:en => 'Clothes for Women', :'zh-CN' => '女性时尚', :de => 'Damenmode'}
    )

    Category.create!(
        :code => 'L2-245',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Body Shapers'},
        :status => false
    )

    Category.create!(
        :code => 'L2-66',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Outerwear & Woven Other Textile Materials'},
        :status => false
    )

    Category.create!(
        :code => 'L2-77',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Dresses', :'zh-CN' => '连衣裙', :de => 'Kleider'}
    )


    Category.create!(
        :code => 'L2-80',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Lingerie'},
        :status => false
    )

    Category.create!(
        :code => 'L2-75',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Skirts, Skorts & Culottes', :'zh-CN' => '短裙 & 裤裙', :de => 'Röcke & Hosenröcke'}
    )

    Category.create!(
        :code => 'L2-248',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Suits, Suit Jackets & Blazers', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Jackets'}
    )

    Category.create!(
        :code => 'L2-78',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Sweaters & Sweatshirts'},
        :status => false
    )

    Category.create!(
        :code => 'L2-246',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Swimwear & Leisurewear'},
        :status => false
    )

    Category.create!(
        :code => 'L2-79',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Trousers, Shorts & Jeans', :'zh-CN' => '长短裤 & 牛仔', :de => 'Hosen & Kurzhosen'}
    )

    Category.create!(
        :code => 'L2-81',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Wedding & Prom Dresses'},
        :status => false
    )

    Category.create!(
        :code => 'L2-591',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Outerwear & Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
    )

    Category.create!(
        :code => 'L2-670',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
        :status => false
    )

    Category.create!(
        :code => 'L2-593',
        :parent => category_clothes_for_women,
        :name_translations => {:en => 'Other Garments'},
        :status => false
    )

    #
    # clothes for babies & essentials - level 1
    #
    category_clothes_for_babies_essentials = Category.create!(
        :code => 'L1-331',
        :parent => category_fashion,
        :name_translations => {:en => 'Clothes for Babies & Essentials', :'zh-CN' => '婴儿衣装 & 用品', :de => 'Babybekleidung & Babybedarf'}
    )

    Category.create!(
        :code => 'L2-332',
        :parent => category_clothes_for_babies_essentials,
        :name_translations => {:en => 'Baby Clothes of cotton', :'zh-CN' => '婴儿棉质衣装', :de => 'Babybekleidungen'}
    )

    Category.create!(
        :code => 'L2-334',
        :parent => category_clothes_for_babies_essentials,
        :name_translations => {:en => 'Baby Clothes of Synthetic Fibre'},
        :status => false
    )


    Category.create!(
        :code => 'L2-356',
        :parent => category_clothes_for_babies_essentials,
        :name_translations => {:en => 'Baby Essentials', :'zh-CN' => '婴儿用品', :de => 'Babybedarf'}
    )

    #
    # clothes for children - level 1
    #
    category_clothes_for_children = Category.create!(
        :code => 'L1-414',
        :parent => category_fashion,
        :name_translations => {:en => 'Clothes for Children', :'zh-CN' => '儿童时尚', :de => 'Kindermode'}
    )

    Category.create!(
        :code => 'L2-415',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Outerwear', :'zh-CN' => '外衣', :de => 'Oberkleidungen'}
    )

    Category.create!(
        :code => 'L2-428',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Suits, Jackets & Dresses', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Kleider'}
    )

    Category.create!(
        :code => 'L2-446',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Sweaters & Sweatshirts', :'zh-CN' => '毛衣 & 运动衫', :de => 'Pullis & Sweatshirts'}
    )

    Category.create!(
        :code => 'L2-452',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Swimwear & Leisurewear'},
        :status => false
    )

    Category.create!(
        :code => 'L2-462',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'T-Shirts, Shirts & Blouses', :'zh-CN' => '体恤衫 & 女衬衫', :de => 'T-Shirts & Blusen'}
    )

    Category.create!(
        :code => 'L2-474',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Trousers, Jeans & Skirts', :'zh-CN' => '长裤 & 裙子', :de => 'Hosen & Röcke'}
    )

    Category.create!(
        :code => 'L2-522',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Underwear & Sleepwear', :'zh-CN' => '内衣 & 睡衣', :de => 'Unterwäschen & Nachtwäsche'}
    )

    Category.create!(
        :code => 'L2-541',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Used & Worn Clothing'},
        :status => false
    )

    Category.create!(
        :code => 'L2-606',
        :parent => category_clothes_for_children,
        :name_translations => {:en => 'Socks & Tights', :'zh-CN' => '袜子 & 裤袜', :de => 'Socken & Strumpfhosen'}
    )


    #
    # health & beauty category - level 1
    #
    category_health_beauty = Category.create!(
        :code => 'L1-84',
        :parent => category_fashion,
        :name_translations => {:en => 'Health & Beauty', :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege'}
    )

    Category.create!(
        :code => 'L2-91',
        :parent => category_health_beauty,
        :name_translations => {:en => 'Fragrances'},
        :status => false
    )

    Category.create!(
        :code => 'L2-277',
        :parent => category_health_beauty,
        :name_translations => {:en => 'Supplements', :'zh-CN' => '增补品', :de => 'Ergänzungen'}
    )

    #
    # home & garden category - level 1
    #
    category_home_garden = Category.create!(
        :code => 'L1-150',
        :parent => category_toys_home,
        :name_translations => {:en => 'Home & Garden', :'zh-CN' => '家居 & 庭院', :de => 'Haushalt & Garten'}
    )

    category_home_accessories = Category.create!(
        :code => 'L2-273',
        :parent => category_home_garden,
        :name_translations => {:en => 'Home Accessories', :'zh-CN' => '家具饰品', :de => 'Haushaltsartikel'}
    )

    Category.create!(
        :code => 'L2-275',
        :parent => category_home_garden,
        :name_translations => {:en => 'Kitchen Accessories', :'zh-CN' => '厨房用品', :de => 'Küchenaccessoires'}
    )

    Category.create!(
        :code => 'L2-173',
        :parent => category_home_garden,
        :name_translations => {:en => 'Lighting', :'zh-CN' => '照明', :de => 'Beleuchtungen'}
    )


    Category.create!(
        :code => 'L2-388',
        :parent => category_home_garden,
        :name_translations => {:en => 'Furniture & Baby Furniture', :'zh-CN' => '家具 & 婴儿家具', :de => 'Möbel & Baby-Einrichtungen'}
    )


    Category.create!(
        :code => 'L2-639',
        :parent => category_home_garden,
        :name_translations => {:en => 'Kitchenware & Tableware', :'zh-CN' => '厨房用具 & 餐具', :de => 'Küchengeräte & Geschirre'}
    )

    Category.create!(
        :code => 'L2-640',
        :parent => category_home_garden,
        :name_translations => {:en => 'Cutlery & Kitchen Utensils', :'zh-CN' => '刀具', :de => 'Bestecke'}
    )


    Category.create!(
        :code => 'L2-641',
        :parent => category_home_garden,
        :name_translations => {:en => 'Cookware', :'zh-CN' => '炊具', :de => 'Kochgeschirre'}
    )

    #
    # jewellery & watches category - level 1
    #
    category_jewellery_watches = Category.create!(
        :code => 'L1-321',
        :parent => category_fashion,
        :name_translations => {:en => 'Jewellery & Watches', :'zh-CN' => '首饰 & 表', :de => 'Schmuck & Uhren'}
    )

    Category.create!(
        :code => 'L2-322',
        :parent => category_jewellery_watches,
        :name_translations => {:en => 'Jewellery of Precious Metals', :'zh-CN' => '金银首饰', :de => 'Edelmetallschmuck'}
    )

    Category.create!(
        :code => 'L2-325',
        :parent => category_jewellery_watches,
        :name_translations => {:en => 'Pearls, Precious & Semiprecious Stones', :'zh-CN' => '珍珠 & 宝石首饰', :de => 'Perlenschmuck & Edelsteinschmuck'}
    )

    Category.create!(
        :code => 'L2-561',
        :parent => category_jewellery_watches,
        :name_translations => {:en => 'Clocks'},
        :status => false
    )

    Category.create!(
        :code => 'L2-563',
        :parent => category_jewellery_watches,
        :name_translations => {:en => 'Watch & Clock Parts', :'zh-CN' => '手表 & 钟表及部件', :de => 'Armbanduhren & Uhrenteile'}
    )

    #
    # toys & games category - level 1
    #
    category_toys_games = Category.create!(
        :code => 'L1-329',
        :parent => category_toys_home,
        :name_translations => {:en => 'Toys & Games', :'zh-CN' => '玩具 & 游戏', :de => 'Spielzeuge & Spiele'}
    )

    Category.create!(
        :code => 'L2-220',
        :parent => category_toys_games,
        :name_translations => {:en => 'Figures & Dolls', :'zh-CN' => '玩具娃娃', :de => 'Figuren & Puppen'}
    )

    Category.create!(
        :code => 'L2-227',
        :parent => category_toys_games,
        :name_translations => {:en => 'Model Vehicles, Slot Racing & Radio-Controlled Toys', :'zh-CN' => '模型 & 遥控玩具', :de => 'Modelfahrzeuge & Ferngesteuerte Spielzeuge'}
    )

    Category.create!(
        :code => 'L2-664',
        :parent => category_toys_games,
        :name_translations => {:en => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys', :'zh-CN' => '三轮车 & 脚蹬车', :de => 'Dreiräder & Roller'}
    )

    Category.create!(
        :code => 'L2-229',
        :parent => category_toys_games,
        :name_translations => {:en => 'Other Toys & Games', :'zh-CN' => '其他玩具', :de => 'Andere Spielzeuge'}
    )

    #
    # food & drink category - level 1
    #
    Category.create!(
        :code => 'L2-581',
        :parent => category_food_drinks,
        :name_translations => {:en => 'wine < 15%vol: red - produced in E.U.', :'zh-CN' => '红葡萄酒', :de => 'Rotwein'}
    )

    Category.create!(
        :code => 'L2-579',
        :parent => category_food_drinks,
        :name_translations => {:en => 'champagne & other sparkling wines', :'zh-CN' => '气泡酒', :de => 'Sekt'}
    )

    Category.create!(
        :code => 'L2-580',
        :parent => category_food_drinks,
        :name_translations => {:en => 'champagne & other sparkling wines', :'zh-CN' => '白葡萄酒', :de => 'Weißwein'}
    )

    Category.create!(
        :code => 'L2-97',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Non-alcoholic Beverages', :'zh-CN' => '软饮料', :de => 'Alkoholfreie Getränke'}
    )

    Category.create!(
        :code => 'L2-587',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Spirits', :'zh-CN' => '烈酒', :de => 'Spirituosen'}
    )

    Category.create!(
        :code => 'L2-633',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Sweets, Snacks & Confectionery', :'zh-CN' => '糖果 & 零食', :de => 'Süßigkeiten & Snacks'}
    )

    Category.create!(
        :code => 'L2-635',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Fruit, Nuts, Seeds & Vegetables', :'zh-CN' => '干果 & 坚果', :de => 'Nüsse & Früchte'}
    )

    Category.create!(
        :code => 'L2-665',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Jams, Honey & Spreads', :'zh-CN' => '果酱 & 蜂蜜 ', :de => 'Konfitüren & Honige'}
    )

    Category.create!(
        :code => 'L2-666',
        :parent => category_food_drinks,
        :name_translations => {:en => 'Oils, Herbs & Spices', :'zh-CN' => '烹饪色拉油 & 佐料', :de => 'Öle, Kräuter & Gewürze'}
    )

    #
    # category shoes & footwear - level 1
    #
    category_shoes_footwear = Category.create!(
        :code => 'L1-661',
        :parent => category_fashion,
        :name_translations => {:en => 'Shoes & Footwear'},
        :status => false
    )

    Category.create!(
        :code => 'L2-543',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins'},
        :status => false
    )

    Category.create!(
        :code => 'L2-602',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins'},
        :status => false
    )

    Category.create!(
        :code => 'L2-603',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins'},
        :status => false
    )

    Category.create!(
        :code => 'L2-613',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Men | house slippers'},
        :status => false
    )

    Category.create!(
        :code => 'L2-616',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Women | house slippers'},
        :status => false
    )

    Category.create!(
        :code => 'L2-619',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Boots & High Tops'},
        :status => false
    )

    Category.create!(
        :code => 'L2-620',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Children | House Slippers'},
        :status => false
    )

    Category.create!(
        :code => 'L2-621',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Children | Sandals & Flip Flops'},
        :status => false
    )

    Category.create!(
        :code => 'L2-600',
        :parent => category_shoes_footwear,
        :name_translations => {:en => 'Other Footwear'},
        :status => false
    )


  end

  desc 'create sample data'
  task samples: :environment do
    I18n.locale = :de

    #Address.all.delete
    #ShopApplication.all.delete

    OrderItem.all.delete
    Order.all.delete

    #
    # creates image upload file
    #
    def create_upload_from_image_file(model, image_name, content_type = 'image/jpeg')
      file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
      file.original_filename = image_name
      file.content_type = content_type
      file
    end

    u = User.find_by(:email => 'shopkeeper01@hotmail.com')

    if u
      u.shop.products.delete_all if u.shop && u.shop.products
      u.shop.save! if u.shop
      u.shop.delete if u.shop
      u.save!
      u.delete
    end

    u = User.find_by(:email => 'shopkeeper02@hotmail.com')

    if u
      u.shop.products.delete_all if u.shop && u.shop.products
      u.shop.save! if u.shop
      u.shop.delete if u.shop
      u.save!
      u.delete
    end

    u = User.find_by(:email => 'customer01@hotmail.com')

    if u
      u.orders.delete_all if u.orders
      u.save!
      u.delete
    end

    u = User.find_by(:email => 'customer02@hotmail.com')

    if u
      u.orders.delete_all if u.orders
      u.save!
      u.delete
    end

    u = User.find_by(:email => 'admin@hotmail.com')
    u.delete if u


    User.create!(:username => 'admin', :email => 'admin@hotmail.com', :password => '12345678', :password_confirmation => '12345678', :role => :admin)

    customer = User.create!(:username => 'customer01', :email => 'customer01@hotmail.com', :gender => 'm', :birth => '1978-01-01', :password => '12345678', :password_confirmation => '12345678', :role => :customer)
    customer.oCollections.create!(:name_translations => 'My Son', :public => true)
    customer.oCollections.create!(:name_translations => 'My Wife', :public => false)

    customer = User.create!(:username => 'customer02', :email => 'customer02@hotmail.com', :gender => 'f', :birth => '1978-02-01', :password => '12345678', :password_confirmation => '12345678', :role => :customer)
    customer.oCollections.create!(:name_translations => 'My Son', :public => true)
    customer.oCollections.create!(:name_translations => 'My Wife', :public => false)

    shopkeeper = User.create!(:username => 'shopkeeper01', :email => 'shopkeeper01@hotmail.com', :password => '12345678', :password_confirmation => '12345678', :role => :shopkeeper)

    shop = Shop.create!(
        :name_translations => 'Herz-Buffet 01',
        :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
        :logo => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
        :banner => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg'),
        :min_total => 20,
        :shopkeeper => shopkeeper,
        :founding_year => 1988,
        :register => 12345678,
        :philosophy => 'my philosohpy',
        :stories => 'my stories',
        :agb => true,
        :tax_number => '12345678',
        :ustid => 'DE123456789',
        :sales_channels => [:third_online_platform, 'www.taobao.com'],
        :shopname => 'Herz-Buffet 01',
        :fname => 'Ray',
        :lname => 'Liu',
        :tel => '08912345678',
        :mail => 'ray.liu@hotmai.com'
    );

    product = Product.new(
        :name_translations => '10 Blatt Seidenpapier ♥ Panda ♥ 01',
        :desc => %Q{
      ♥ 10 Bögen Seidenpapier
      ♥ Panda
      ♥ Größe je Bogen: 50 x 70cm
      ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
      ♥ Das Papier wird auf 18x25cm gefaltet versendet
    },
        :brand => 'Herz-Buffet',
        :tags => ['壁纸', '熊猫', 'buffet'],
        :shop => shop
    )

    v1 = VariantOption.new(:name_translations => 'Größe', :product => product)
    v1_o1 = VariantOption.new(:parent => v1, :name_translations => 'klein')
    v1_o2 = VariantOption.new(:parent => v1, :name_translations => 'mittel')
    v1_o3 = VariantOption.new(:parent => v1, :name_translations => 'groß')

    v2 = VariantOption.new(:name_translations => 'Farbe', :product => product)
    v2_o1 = VariantOption.new(:parent => v2, :name_translations => 'rot')
    v2_o2 = VariantOption.new(:parent => v2, :name_translations => 'blue')
    v2_o3 = VariantOption.new(:parent => v2, :name_translations => 'gold')

    s1 = Sku.new(:price => 10, :product => product, :quantity => 5, :weight => 10, :unit => 'g', :discount => 10, :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s1.option_ids << v1_o1.id.to_s
    s1.option_ids << v2_o1.id.to_s
    s1.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.save!

    s2 = Sku.new(:price => 10, :product => product, :quantity => 4, :weight => 10, :unit => 'g', :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s2.option_ids << v1_o2.id.to_s
    s2.option_ids << v2_o1.id.to_s
    s2.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.save!

    s3 = Sku.new(:price => 20, :product => product, :limited => true, :quantity => 3, :weight => 10, :unit => 'g', :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s3.option_ids << v1_o3.id.to_s
    s3.option_ids << v2_o3.id.to_s
    s3.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.save!

    shop.products << product
    shop.save!


    shopkeeper = User.create!(:username => 'shopkeeper02', :email => 'shopkeeper02@hotmail.com', :password => '12345678', :password_confirmation => '12345678', :role => :shopkeeper)

    shop = Shop.create!(
        :name_translations => 'Herz-Buffet 02',
        :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
        :logo => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
        :banner => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg'),
        :min_total => 20,
        :shopkeeper => shopkeeper,
        :founding_year => 1988,
        :register => 12345678,
        :philosophy => 'my philosohpy',
        :stories => 'my stories',
        :agb => true,
        :tax_number => '12345678',
        :ustid => 'DE123456789',
        :sales_channels => [:third_online_platform, 'www.taobao.com'],
        :shopname => 'Herz-Buffet 02',
        :fname => 'Ray',
        :lname => 'Liu',
        :tel => '08912345678',
        :mail => 'ray.liu@hotmai.com'
    );

    product = Product.new(
        :name_translations => '10 Blatt Seidenpapier ♥ Panda ♥ 02',
        :desc => %Q{
        ♥ 10 Bögen Seidenpapier
        ♥ Panda
        ♥ Größe je Bogen: 50 x 70cm
        ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
        ♥ Das Papier wird auf 18x25cm gefaltet versendet
        },
        :cover => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
        :brand => 'Herz-Buffet',
        :tags => ['壁纸', '熊猫', 'buffet'],
        :shop => shop
    )

    v1 = VariantOption.new(:name_translations => 'Größe', :product => product)
    v1_o1 = VariantOption.new(:parent => v1, :name_translations => 'klein')
    v1_o2 = VariantOption.new(:parent => v1, :name_translations => 'mittel')
    v1_o3 = VariantOption.new(:parent => v1, :name_translations => 'groß')

    v2 = VariantOption.new(:name_translations => 'Farbe', :product => product)
    v2_o1 = VariantOption.new(:parent => v2, :name_translations => 'rot')
    v2_o2 = VariantOption.new(:parent => v2, :name_translations => 'blau')
    v2_o3 = VariantOption.new(:parent => v2, :name_translations => 'gold')

    s1 = Sku.new(:price => 10, :product => product, :quantity => 5, :weight => 10, :unit => 'g', :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s1.option_ids << v1_o1.id.to_s
    s1.option_ids << v2_o1.id.to_s
    s1.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s1.save!

    s2 = Sku.new(:price => 10, :product => product, :quantity => 4, :weight => 10, :unit => 'g', :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s2.option_ids << v1_o2.id.to_s
    s2.option_ids << v2_o1.id.to_s
    s2.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s2.save!

    s3 = Sku.new(:price => 20, :product => product, :limited => true, :quantity => 3, :weight => 10, :unit => 'g', :space_length => 1.0, :space_width => 2.0, :space_height => 3.0)
    s3.option_ids << v1_o3.id.to_s
    s3.option_ids << v2_o3.id.to_s
    s3.img0 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img1 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img2 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.img3 = create_upload_from_image_file(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg')
    s3.save!

    shop.products << product
    shop.save!

    Rails.cache.clear
  end

end
