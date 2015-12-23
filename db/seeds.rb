Category.all.delete

#
# food & drink category
#
category_food_drink = Category.create!(
    :name => 'Food & Drink',
    :cssc => 'fa-cutlery'
)

#
# events category
#
category_events = Category.create!(
    :name => 'Events',
    :cssc => 'fa-calendar'
)

#
# beauty category
#
category_beauty = Category.create!(
    :name => 'Beauty',
    :cssc => 'fa-female'
)

#
# fitness category
#
category_fitness = Category.create!(
    :name => 'Fitness',
    :cssc => 'fa-bolt'
)

#
# electronics category
#
category_electronics = Category.create!(
    :name => 'Electronics',
    :cssc => 'fa-headphones'
)

#
# furniture category
#
category_furniture = Category.create!(
    :name => 'Furniture',
    :cssc => 'fa-image'
)

#
# fashion category
#
category_fashion = Category.create!(
    :name => 'Fashion',
    :cssc => 'fa-umbrella'
)

#
# shopping category
#
category_shopping = Category.create!(
    :name => 'Shopping',
    :cssc => 'fa-shopping-cart'
)

#
# home & garden category
#
category_home_garden = Category.create!(
    :name => 'Home & Garden',
    :cssc => 'fa-home'
)

category_carpet = Category.create!(
    :name => 'Carpet',
    :parent => category_home_garden
)

#
# travel category
#
category_tavel = Category.create!(
    :name => 'Tavel',
    :cssc => 'fa-plane'
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
Product.where(:name => '10 Blatt Seidenpapier ♥ Panda ♥').delete;

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
    :price => 10.0
)

product.categories << category_carpet
product.save!