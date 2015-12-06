# function to create shop image from file
def get_demo_image(model, image_name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
  file.original_filename = image_name
  file.content_type = content_type
  file
end

Shop.all.delete;
ShopInfo.all.delete;
ProductInfo.all.delete;
Product.where(:name => '10 Blatt Seidenpapier').delete;

shop = Shop.create!(
  :name => 'Herz-Buffet', 
  :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
  :logo => get_demo_image(Shop.name.downcase, 'herz-buffet-logo.jpg'),
  :banner => get_demo_image(Shop.name.downcase, 'herz-buffet-banner.jpg')
);

shopInfo = ShopInfo.create!(
  :name => 'Herz-Buffet', 
  :logo => get_demo_image(Shop.name.downcase, 'herz-buffet-logo.jpg'),
  :shop => shop
);

product = Product.create!(
  :name => '10 Blatt Seidenpapier',
  :desc => %Q{
  ♥ 10 Bögen Seidenpapier
  ♥ Panda
  ♥ Größe je Bogen: 50 x 70cm
  ♥ Das Papier eignet sich nicht nur wundervoll zum Verpacken
  ♥ Das Papier wird auf 18x25cm gefaltet versendet
  },
  :img => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/square_130.JPEG',
  :imglg => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
);

productInfo = ProductInfo.create!(
  :name => '10 Blatt Seidenpapier ♥ Panda ♥',
  :thum => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/square_130.JPEG',
  :product => product,
  :shop_info => shopInfo
);

# Product.distinct(:shopname).each do |s|
#   shop = Shop.create!( :name => :shopname )
#   shopInfo = ShopInfo.create!( :name => :shopname )
# end