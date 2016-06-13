require 'csv'

DutyCategory.all.delete

csv_file = File.join(Rails.root, 'vendor', 'bg-duty-categories.csv')
CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: true) do |row|
    if row[2].blank?
      DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[1].strip} )
    else
      if row[3].blank?
        parent = DutyCategory.find_by(:'name.en' => row[1].strip)
        DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[2].strip}, :parent => parent )
      else
          if row[4].blank?
            parent = DutyCategory.find_by(:'name.en' => row[2].strip)
            DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[3].strip}, :parent => parent )
          else
            parent = DutyCategory.find_by(:'name.en' => row[3].strip)
            DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[4].strip}, :parent => parent )
          end
      end
    end
end

=begin
#
# bags & accessories category - level 1
#
category_bags_accessories = DutyCategory.create!(
    :code => 'L1-1',
    :name_translations => {:en => 'Bags & Accessories', :'zh-CN' => '包包 & 配饰', :de => 'Taschen & Accessoires'}
)

DutyCategory.create!(
    :code => 'L2-251',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Belts', :'zh-CN' => '腰带', :de => 'Gürtel'}
)

DutyCategory.create!(
    :code => 'L2-291',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Bag Accessories'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-404',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Gloves & Ear Muffs'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-406',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Sunglasses', :'zh-CN' => '太阳镜', :de => 'Sonnenbrillen'}
)

DutyCategory.create!(
    :code => 'L2-624',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Briefcases, School Satchels & Messenger Bags'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-626',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Handbags, Clutches & Shoulder Bags', :'zh-CN' => '手包 & 背包', :de => 'Handtaschen & Umhängetaschen'}
)

DutyCategory.create!(
    :code => 'L2-627',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Purses, Pouches & Wallets', :'zh-CN' => '钱包 & 小包', :de => 'Portemonnaies & Pouches'}
)

DutyCategory.create!(
    :code => 'L2-628',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Travel Bags, Toilet Bags, Rucksacks & Sports Bags'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-645',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Scarves, Shawls & Veils', :'zh-CN' => '围巾 & 披肩', :de => 'Tücher & Schleier'}
)

DutyCategory.create!(
    :code => 'L2-646',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Key Rings & Moneyclips'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-649',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Wristbands'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-244',
    :parent => category_bags_accessories,
    :name_translations => {:en => 'Other Accessories', :'zh-CN' => '其他配饰', :de => 'Andere Accessoires'}
)

#
# clothes for men category - level 1
#
category_clothes_for_men = DutyCategory.create!(
    :code => 'L1-47',
    :name_translations => {:en => 'Clothes for Men', :'zh-CN' => '男性时尚', :de => 'Herrenmode'},
)

DutyCategory.create!(
    :code => 'L2-63',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-48',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Woven Cotton or Wool & Fine Animal Hair'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-50',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Suits, Suit Jackets & Blazers'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-53',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-51',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'T-Shirts, Shirts & Polos', :'zh-CN' => '体恤 & Polo衫', :de => 'T-Shirts & Poloshirts'}
)

DutyCategory.create!(
    :code => 'L2-52',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Trousers, Shorts & Jeans'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-596',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

DutyCategory.create!(
    :code => 'L2-669',
    :parent => category_clothes_for_men,
    :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)


#
# clothes for women category - level 1
#
category_clothes_for_women = DutyCategory.create!(
    :code => 'L1-64',
    :name_translations => {:en => 'Clothes for Women', :'zh-CN' => '女性时尚', :de => 'Damenmode'}
)

DutyCategory.create!(
    :code => 'L2-245',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Body Shapers'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-66',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear & Woven Other Textile Materials'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-77',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Dresses', :'zh-CN' => '连衣裙', :de => 'Kleider'}
)

DutyCategory.create!(
    :code => 'L2-80',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Lingerie'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-75',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Skirts, Skorts & Culottes', :'zh-CN' => '短裙 & 裤裙', :de => 'Röcke & Hosenröcke'}
)

DutyCategory.create!(
    :code => 'L2-248',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Suits, Suit Jackets & Blazers', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Jackets'}
)

DutyCategory.create!(
    :code => 'L2-78',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Sweaters & Sweatshirts'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-246',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-79',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Trousers, Shorts & Jeans', :'zh-CN' => '长短裤 & 牛仔', :de => 'Hosen & Kurzhosen'}
)

DutyCategory.create!(
    :code => 'L2-81',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Wedding & Prom Dresses'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-591',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear & Knitted', :'zh-CN' => '外衣 & 织衣', :de => 'Oberbekleidungen & Strickkleider'}
)

DutyCategory.create!(
    :code => 'L2-670',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Outerwear, Leather, Fur & Plastic'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-593',
    :parent => category_clothes_for_women,
    :name_translations => {:en => 'Other Garments'},
    :status => false
)

#
# clothes for babies & essentials - level 1
#
category_clothes_for_babies_essentials = DutyCategory.create!(
    :code => 'L1-331',
    :name_translations => {:en => 'Clothes for Babies & Essentials', :'zh-CN' => '婴儿衣装 & 用品', :de => 'Babybekleidung & Babybedarf'}
)

DutyCategory.create!(
    :code => 'L2-332',
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Clothes of cotton', :'zh-CN' => '婴儿棉质衣装', :de => 'Babybekleidungen'}
)

DutyCategory.create!(
    :code => 'L2-334',
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Clothes of Synthetic Fibre'},
    :status => false
)


DutyCategory.create!(
    :code => 'L2-356',
    :parent => category_clothes_for_babies_essentials,
    :name_translations => {:en => 'Baby Essentials', :'zh-CN' => '婴儿用品', :de => 'Babybedarf'}
)

#
# clothes for children - level 1
#
category_clothes_for_children = DutyCategory.create!(
    :code => 'L1-414',
    :name_translations => {:en => 'Clothes for Children', :'zh-CN' => '儿童时尚', :de => 'Kindermode'}
)

DutyCategory.create!(
    :code => 'L2-415',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Outerwear', :'zh-CN' => '外衣', :de => 'Oberkleidungen'}
)

DutyCategory.create!(
    :code => 'L2-428',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Suits, Jackets & Dresses', :'zh-CN' => '套装 & 外套', :de => 'Anzüge & Kleider'}
)

DutyCategory.create!(
    :code => 'L2-446',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Sweaters & Sweatshirts', :'zh-CN' => '毛衣 & 运动衫', :de => 'Pullis & Sweatshirts'}
)

DutyCategory.create!(
    :code => 'L2-452',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Swimwear & Leisurewear'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-462',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'T-Shirts, Shirts & Blouses', :'zh-CN' => '体恤衫 & 女衬衫', :de => 'T-Shirts & Blusen'}
)

DutyCategory.create!(
    :code => 'L2-474',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Trousers, Jeans & Skirts', :'zh-CN' => '长裤 & 裙子', :de => 'Hosen & Röcke'}
)

DutyCategory.create!(
    :code => 'L2-522',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Underwear & Sleepwear', :'zh-CN' => '内衣 & 睡衣', :de => 'Unterwäschen & Nachtwäsche'}
)

DutyCategory.create!(
    :code => 'L2-541',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Used & Worn Clothing'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-606',
    :parent => category_clothes_for_children,
    :name_translations => {:en => 'Socks & Tights', :'zh-CN' => '袜子 & 裤袜', :de => 'Socken & Strumpfhosen'}
)

#
# health & beauty category - level 1
#
category_health_beauty = DutyCategory.create!(
    :code => 'L1-84',
    :name_translations => {:en => 'Health & Beauty', :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege'}
)

DutyCategory.create!(
    :code => 'L2-278',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Bath & Shower', :'zh-CN' => '沐浴', :de => 'Bad & Dusche'}
)

DutyCategory.create!(
    :code => 'L2-91',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Fragrances'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-92',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Hair Care', :'zh-CN' => '护发', :de => 'Haarpflege'}
)

DutyCategory.create!(
    :code => 'L2-94',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Skin Care, Cosmetics & Tanning', :'zh-CN' => '护肤 & 化妆品', :de => 'Hautpflege & Kosmetik'}
)

DutyCategory.create!(
    :code => 'L2-277',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Supplements', :'zh-CN' => '增补品', :de => 'Ergänzungen'}
)

DutyCategory.create!(
    :code => 'L2-662',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Massage & Orthopaedic', :'zh-CN' => '按摩用品', :de => 'Massage & Orthopädie'}
)

DutyCategory.create!(
    :code => 'L2-276',
    :parent => category_health_beauty,
    :name_translations => {:en => 'Medicine & Vitamins', :'zh-CN' => '药品和保健品', :de => 'Medikament & Nahrungsergänzung'}
)

#
# home & garden category - level 1
#
category_home_garden = DutyCategory.create!(
    :code => 'L1-150',
    :name_translations => {:en => 'Home & Garden', :'zh-CN' => '家居 & 庭院', :de => 'Haushalt & Garten'}
)

category_home_accessories = DutyCategory.create!(
    :code => 'L2-273',
    :parent => category_home_garden,
    :name_translations => {:en => 'Home Accessories', :'zh-CN' => '家具饰品', :de => 'Haushaltsartikel'}
)

DutyCategory.create!(
    :code => 'L2-275',
    :parent => category_home_garden,
    :name_translations => {:en => 'Kitchen Accessories', :'zh-CN' => '厨房用品', :de => 'Küchenaccessoires'}
)

DutyCategory.create!(
    :code => 'L2-173',
    :parent => category_home_garden,
    :name_translations => {:en => 'Lighting', :'zh-CN' => '照明', :de => 'Beleuchtungen'}
)

DutyCategory.create!(
    :code => 'L2-388',
    :parent => category_home_garden,
    :name_translations => {:en => 'Furniture & Baby Furniture', :'zh-CN' => '家具 & 婴儿家具', :de => 'Möbel & Baby-Einrichtungen'}
)

DutyCategory.create!(
    :code => 'L2-639',
    :parent => category_home_garden,
    :name_translations => {:en => 'Kitchenware & Tableware', :'zh-CN' => '厨房用具 & 餐具', :de => 'Küchengeräte & Geschirre'}
)

DutyCategory.create!(
    :code => 'L2-640',
    :parent => category_home_garden,
    :name_translations => {:en => 'Cutlery & Kitchen Utensils', :'zh-CN' => '刀具', :de => 'Bestecke'}
)

DutyCategory.create!(
    :code => 'L2-641',
    :parent => category_home_garden,
    :name_translations => {:en => 'Cookware', :'zh-CN' => '炊具', :de => 'Kochgeschirre'}
)

#
# jewellery & watches category - level 1
#
category_jewellery_watches = DutyCategory.create!(
    :code => 'L1-321',
    :name_translations => {:en => 'Jewellery & Watches', :'zh-CN' => '首饰 & 表', :de => 'Schmuck & Uhren'}
)

DutyCategory.create!(
    :code => 'L2-322',
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Jewellery of Precious Metals', :'zh-CN' => '金银首饰', :de => 'Edelmetallschmuck'}
)

DutyCategory.create!(
    :code => 'L2-325',
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Pearls, Precious & Semiprecious Stones', :'zh-CN' => '珍珠 & 宝石首饰', :de => 'Perlenschmuck & Edelsteinschmuck'}
)

DutyCategory.create!(
    :code => 'L2-561',
    :parent => category_jewellery_watches,
    :name_translations => {:en  => 'Clocks'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-563',
    :parent => category_jewellery_watches,
    :name_translations => {:en => 'Watch & Clock Parts', :'zh-CN' => '手表 & 钟表及部件', :de => 'Armbanduhren & Uhrenteile'}
)

#
# toys & games category - level 1
#
category_toys_games = DutyCategory.create!(
    :code => 'L1-329',
    :name_translations => {:en => 'Toys & Games', :'zh-CN' => '玩具 & 游戏', :de => 'Spielzeuge & Spiele'}
)

DutyCategory.create!(
    :code => 'L2-220',
    :parent => category_toys_games,
    :name_translations => {:en => 'Figures & Dolls', :'zh-CN' => '玩具娃娃', :de => 'Figuren & Puppen'}
)

DutyCategory.create!(
    :code => 'L2-227',
    :parent => category_toys_games,
    :name_translations => {:en => 'Model Vehicles, Slot Racing & Radio-Controlled Toys', :'zh-CN' => '模型 & 遥控玩具', :de => 'Modelfahrzeuge & Ferngesteuerte Spielzeuge'}
)

DutyCategory.create!(
    :code => 'L2-664',
    :parent => category_toys_games,
    :name_translations => {:en => 'Tricycles, Scooters, Pedal Cars & Ride-On Toys', :'zh-CN' => '三轮车 & 脚蹬车', :de => 'Dreiräder & Roller'}
)

DutyCategory.create!(
    :code => 'L2-229',
    :parent => category_toys_games,
    :name_translations => {:en => 'Other Toys & Games', :'zh-CN' => '其他玩具', :de => 'Andere Spielzeuge'}
)

#
# food & drink category - level 1
#
category_food_drinks = DutyCategory.create!(
    :code => 'L1-578',
    :name_translations => {:en => 'Food & Drinks', :'zh-CN' => '食品和饮料', :de => 'Lebensmittel  & Getränke'}
)

DutyCategory.create!(
    :code => 'L2-97',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Non-alcoholic Beverages', :'zh-CN' => '软饮料', :de => 'Alkoholfreie Getränke'}
)

DutyCategory.create!(
    :code => 'L2-587',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Spirits', :'zh-CN' => '烈酒', :de => 'Spirituosen'}
)

DutyCategory.create!(
    :code => 'L2-633',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Sweets, Snacks & Confectionery', :'zh-CN' => '糖果 & 零食', :de => 'Süßigkeiten & Snacks'}
)

DutyCategory.create!(
    :code => 'L2-635',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Fruit, Nuts, Seeds & Vegetables',  :'zh-CN' => '干果 & 坚果', :de => 'Nüsse & Früchte'}
)

DutyCategory.create!(
    :code => 'L2-665',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Jams, Honey & Spreads',  :'zh-CN' => '果酱 & 蜂蜜 ', :de => 'Konfitüren & Honige'}
)

DutyCategory.create!(
    :code => 'L2-666',
    :parent => category_food_drinks,
    :name_translations => {:en => 'Oils, Herbs & Spices', :'zh-CN' => '烹饪色拉油 & 佐料', :de => 'Öle, Kräuter & Gewürze'}
)

#
# category shoes & footwear - level 1
#
category_shoes_footwear = DutyCategory.create!(
    :code => 'L1-661',
    :name_translations => {:name_translations => 'Shoes & Footwear'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-543',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat Shoes & Moccasins' },
    :status => false
)

DutyCategory.create!(
    :code => 'L2-602',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Men | Loafers, Oxfords, Brogues, Mules, Boat Shoes & Moccasins' },
    :status => false
)

DutyCategory.create!(
    :code => 'L2-603',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Women | Pumps, Flats, Oxfords, Brogues, Loafers, Platforms, Mules, Boat shoes & Moccasins' },
    :status => false
)

DutyCategory.create!(
    :code => 'L2-613',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Men | house slippers'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-616',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Women | house slippers'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-619',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Boots & High Tops'},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-620',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Children | House Slippers '},
    :status => false
)

DutyCategory.create!(
    :code => 'L2-621',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Children | Sandals & Flip Flops' },
    :status => false
)

DutyCategory.create!(
    :code => 'L2-600',
    :parent => category_shoes_footwear,
    :name_translations => { :en => 'Other Footwear' },
    :status => false
)

Rails.cache.clear
=end
