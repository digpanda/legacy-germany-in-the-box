# function to create shop image from file
def get_demo_image(model, image_name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
  file.original_filename = image_name
  file.content_type = content_type
  file
end

shop = Shop.new(
  :name => 'Herz-Buffet', 
  :desc => 'Alle Bestellungen werden automatisch bestätigt und können sofort bezahlt werden. Die Versandkosten betragen deutschlandweit pauschal 3,50€, egal wieviel ihr bestellt. Paypalgebühren werden nicht erhoben. Jeder Bestellung liegt eine Rechnung mit ausgewiesener Umsatzsteuer bei.',
  :logo => get_demo_image(Shop.name.downcase, 'herz-buffet-logo.jpg'),
  :banner => get_demo_image(Shop.name.downcase, 'herz-buffet-banner.jpg')
);

shop.upsert;