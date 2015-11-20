# function to create shop image from file
def get_demo_image(model, image_name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
  file.original_filename = image_name
  file.content_type = content_type
  file
end

Shop.where(:name => 'Herz-Buffet').delete;

shop = Shop.create!(
  :name => 'Herz-Buffet', 
  :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
  :logo => get_demo_image(Shop.name.downcase, 'herz-buffet-logo.jpg'),
  :banner => get_demo_image(Shop.name.downcase, 'herz-buffet-banner.jpg')
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
  :img => get_demo_image(Product.name.downcase, 'herz_buffet_small_10_blatt_seidenpapier_panda.jpg'),
  :imglg => get_demo_image(Product.name.downcase, 'herz_buffet_large_10_blatt_seidenpapier_panda.jpg'),
)

shop.save!

