I18n.locale = :de

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
customer.oCollections.create!(:name => 'My Son', :public => true)
customer.oCollections.create!(:name => 'My Wife', :public => false)

customer = User.create!(:username => 'customer02', :email => 'customer02@hotmail.com', :gender => 'f', :birth => '1978-02-01', :password => '12345678', :password_confirmation => '12345678', :role => :customer)
customer.oCollections.create!(:name => 'My Son', :public => true)
customer.oCollections.create!(:name => 'My Wife', :public => false)

shopkeeper = User.create!(:username => 'shopkeeper01', :email => 'shopkeeper01@hotmail.com', :password => '12345678', :password_confirmation => '12345678', :role => :shopkeeper)

shop = Shop.create!(
    :name => 'Herz-Buffet 01',
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
    :name => '10 Blatt Seidenpapier ♥ Panda ♥ 01',
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

v1 = VariantOption.new(:name => 'Größe', :product => product)
v1_o1 = VariantOption.new(:parent => v1, :name => 'klein')
v1_o2 = VariantOption.new(:parent => v1, :name => 'mittel')
v1_o3 = VariantOption.new(:parent => v1, :name => 'groß')

v2 = VariantOption.new(:name => 'Farbe', :product => product)
v2_o1 = VariantOption.new(:parent => v2, :name => 'rot')
v2_o2 = VariantOption.new(:parent => v2, :name => 'blue')
v2_o3 = VariantOption.new(:parent => v2, :name => 'gold')

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
    :name => 'Herz-Buffet 02',
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
    :name => '10 Blatt Seidenpapier ♥ Panda ♥ 02',
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

v1 = VariantOption.new(:name => 'Größe', :product => product)
v1_o1 = VariantOption.new(:parent => v1, :name => 'klein')
v1_o2 = VariantOption.new(:parent => v1, :name => 'mittel')
v1_o3 = VariantOption.new(:parent => v1, :name => 'groß')

v2 = VariantOption.new(:name => 'Farbe', :product => product)
v2_o1 = VariantOption.new(:parent => v2, :name => 'rot')
v2_o2 = VariantOption.new(:parent => v2, :name => 'blau')
v2_o3 = VariantOption.new(:parent => v2, :name => 'gold')

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