Category.all.delete

#
# bags & accessories category
#
category_bags_accessories = Category.create!(
    :name => 'Bags & Accessories',
    :code => 'L1-1',
    :cssc => 'fa-umbrella'
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
    :name => 'Purses, Pouches & Walletss',
    :code => 'L2-627',
    :parent => category_bags_accessories
)

Category.create!(
    :name => 'Travel Bags, Toilet Bags, rucksacks & Sports Bags',
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
# clothes for men category
#
category_clothes_for_men = Category.create!(
    :name => 'Clothes for Men',
    :code => 'L1-47',
    :cssc => 'fa-male'
)

#
# clothes for women category
#
category_clothes_for_women = Category.create!(
    :name => 'Clothes for Women',
    :code => 'L1-64',
    :cssc => 'fa-female'
)

#
# clothes for babies & essentials
#
category_clothes_for_babies_essentials = Category.create!(
    :name => 'Clothes for Babies & Essentials',
    :code => 'L1-331',
    :cssc => 'fa-smile-o'
)

#
# clothes for children
#
category_clothes_for_children = Category.create!(
    :name => 'Clothes for Children',
    :code => 'L1-414',
    :cssc => 'fa-child'
)

#
# health & beauty category
#
category_health_beauty = Category.create!(
    :name => 'Health & Beauty',
    :code => 'L1-84',
    :cssc => 'fa-stethoscope '
)


#
# home & garden category
#
category_home_garden = Category.create!(
    :name => 'Home & Garden',
    :code => 'L1-150',
    :cssc => 'fa-home'
)

category_home_accessories = Category.create!(
    :name => 'Home Accessories',
    :parent => category_home_garden
)


#
# jewellery & watches category
#
category_food_drinks = Category.create!(
    :name => 'Jewellery & Watches',
    :code => 'L1-321',
    :cssc => 'fa-clock-o'
)


#
# toys & games category
#
category_food_drinks = Category.create!(
    :name => 'Toys & Games',
    :code => 'L1-329',
    :cssc => ' fa-gamepad'
)



#
# food & drink category
#
category_food_drinks = Category.create!(
    :name => 'Food & Drinks',
    :code => 'L1-578',
    :cssc => 'fa-cutlery'
)


#
# category shoes & footwear
#
category_food_drinks = Category.create!(
    :name => 'Shoes & Footwear',
    :code => 'L1-661',
    :cssc => 'fa-gift'
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
    :brand => 'Herz-Buffet'
)

product.categories << category_home_accessories
product.save!

product = shop.products.create!(
    :name => '熊猫壁纸',
    :desc => '熊猫壁纸',
    :img => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/square_130.JPEG',
    :imglg => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :price => 10.0,
    :brand => 'Herz-Buffet'
)

product.categories << category_home_accessories
product.save!