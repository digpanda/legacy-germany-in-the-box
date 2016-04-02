#Address.all.delete
#ShopApplication.all.delete

OrderItem.all.delete
Order.all.delete

category_home_accessories = Category.where(:name => 'Home Accessories')

#
# creates image upload file
#
def create_upload_from_image_file(model, image_name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Rails.root, 'db', 'demo', 'images', model, image_name), 'rb'))
  file.original_filename = image_name
  file.content_type = content_type
  file
end

Product.where(:name => /.*10 Blatt Seidenpapier ♥ Panda ♥.*/).all.delete;
Product.where({:name => /.*熊猫壁纸.*/i}).all.delete;
Shop.where(:name => 'Herz-Buffet 01').all.delete;
Shop.where(:name => 'Herz-Buffet 02').all.delete;
User.where(:email => 'shopkeeper01@hotmail.com').all.delete;
User.where(:email => 'shopkeeper02@hotmail.com').all.delete;
User.where(:email => 'dailycron@hotmail.com').all.delete;
User.where(:email => 'customer01@hotmail.com').all.delete;
User.where(:email => 'customer02@hotmail.com').all.delete;
User.where(:email => 'admin@hotmail.com').all.delete;


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
    :statement0 => true,
    :statement1 => true,
    :statement2 => true,
    :agb => true,
    :tax_number => '12345678',
    :ustid => '12345678',
    :sales_channels => [:third_online_platform, 'www.taobao.com']
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

v1 = VariantOption.new(:name => 'Größe', :product => product, :name_locales => { :'zh-CN' => '尺寸'})
v1_o1 = VariantOption.new(:parent => v1, :name => 'klein', :name_locales => { :'zh-CN' => '小号'})
v1_o2 = VariantOption.new(:parent => v1, :name => 'mittel', :name_locales => { :'zh-CN' => '中号'})
v1_o3 = VariantOption.new(:parent => v1, :name => 'groß', :name_locales => { :'zh-CN' => '大号'})

v2 = VariantOption.new(:name => 'Farbe', :product => product,  :name_locales => { :'zh-CN' => '颜色'})
v2_o1 = VariantOption.new(:parent => v2, :name => 'rot', :name_locales => { :'zh-CN' => '红色'})
v2_o2 = VariantOption.new(:parent => v2, :name => 'blue', :name_locales => { :'zh-CN' => '蓝色'})
v2_o3 = VariantOption.new(:parent => v2, :name => 'gold', :name_locales => { :'zh-CN' => '金色'})

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

product.categories << category_home_accessories

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
    :statement0 => true,
    :statement1 => true,
    :statement2 => true,
    :agb => true,
    :tax_number => '12345678',
    :ustid => '12345678',
    :sales_channels => [:third_online_platform, 'www.taobao.com']
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
    #:img0 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img1 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img2 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    #:img3 => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
    :brand => 'Herz-Buffet',
    :tags => ['壁纸', '熊猫', 'buffet'],
    :shop => shop
)

v1 = VariantOption.new(:name => 'Größe', :product => product, :name_locales => { :'zh-CN' => '尺寸' })
v1_o1 = VariantOption.new(:parent => v1, :name => 'klein', :name_locales => { :'zh-CN' => '小号' })
v1_o2 = VariantOption.new(:parent => v1, :name => 'mittel', :name_locales => { :'zh-CN' => '中号' })
v1_o3 = VariantOption.new(:parent => v1, :name => 'groß', :name_locales => { :'zh-CN' => '大号' })

v2 = VariantOption.new(:name => 'Farbe', :product => product,  :name_locales => { :'zh-CN' => '颜色'})
v2_o1 = VariantOption.new(:parent => v2, :name => 'rot', :name_locales => { :'zh-CN' => '红色' })
v2_o2 = VariantOption.new(:parent => v2, :name => 'blau', :name_locales => { :'zh-CN' => '蓝色' })
v2_o3 = VariantOption.new(:parent => v2, :name => 'gold', :name_locales => { :'zh-CN' => '金色' })

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

product.categories << category_home_accessories

shop.products << product
shop.save!

Rails.cache.clear

