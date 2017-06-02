require 'faker'

class Tasks::Digpanda::RemoveAndCreateCompleteSampleData

  WIRECARD_DEMO = Rails.configuration.wirecard[:demo]

  def initialize
  end

  def perform

    #
    # We first remove absolutely everything
    #
    puts "We remove the setting"
    Setting.delete_all
    puts "We remove all users"
    User.delete_all
    puts "We remove all shops"
    Shop.delete_all
    puts "We remove all the payment gateways"
    PaymentGateway.delete_all
    puts "We remove all products"
    Product.delete_all
    puts "We remove all the orders / order payments"
    Order.delete_all
    OrderPayment.delete_all
    puts "We remove all the orders items"
    OrderItem.delete_all
    puts "We remove all addresses"
    Address.delete_all
    puts "We remove all package sets"
    PackageSet.delete_all

    puts "We set the locale to Germany"
    I18n.locale = :de
    Faker::Config.locale = 'de'

    puts "We repopulate the categories from another rake task"
    puts "---"
    Tasks::Digpanda::RemoveAndCreateDutyCategories.new
    Tasks::Digpanda::RemoveAndCreateUiCategories.new
    puts "---"

    puts "We refresh the duty category taxes"
    puts "---"
    Tasks::Digpanda::RefreshDutyCategoriesTaxes.new
    puts "---"

    puts "We create the customers, shopkeepers, admins"

    25.times { setup_customer create_user(:customer) }
    1.times { setup_guide create_user(:customer) }
    3.times { create_user(:admin) }

    10.times { setup_shopkeeper create_user(:shopkeeper) }
    8.times { setup_packageset }

    convert_product_without_first_sku_left(random_product)
    convert_product_with_documentation_attached(random_product)

    Rails.cache.clear

    puts "End of process."

  end

  private

  def convert_product_with_documentation_attached(product)
    puts "We convert #{product.name} to a `with_documentation_attached`"
    product.name += " WITH DOCUMENTATION"
    product.skus.first.data = Faker::Lorem.paragraph
    product.skus.first.attach0 = setup_documentation(:pdf)
    product.save!
  end


  def convert_product_without_first_sku_left(product)
    puts "We convert #{product.name} to a `without_first_sku_left`"
    product.name += " NO FIRST SKU"
    product.desc = "The price of the first Sku is #{product.skus.first.price} and shouldn't appear."
    product.skus.first.quantity = 0
    product.save!
  end

  def create_pricey_sku(product)
    create_sku(product, {
        :price => 500,
      })
  end

  def create_big_sku(product)
    create_sku(product, {
        :weight       => 2.0,
        :space_length => 10,
        :space_width  => 20,
        :space_height => 30
      })
  end

  def create_sku(product, args={})

    price        = args[:price] || (2 * Product.count) + (product.skus.count * 10)
    quantity     = args[:quantity] || rand(1..10)
    num_options  = args[:num_options] || rand(1..5)
    weight       = args[:weight] || 0.5
    space_length = args[:space_length] || 1.0
    space_width  = args[:space_width] || 2.0
    space_height = args[:space_height] || 3.0

    sku = Sku.new(
      :price        => price,
      :product      => product,
      :quantity     => quantity,
      :weight       => weight,
      :space_length => space_length,
      :space_width  => space_width,
      :space_height => space_height,
      :data         => "#{Faker::Lorem.paragraph(1)}\n\n#{Faker::Lorem.paragraph(2)}"
    )

    num_options.times do |time|
      sku.option_ids << product.options.sample.suboptions.sample.id.to_s
    end
    sku.option_ids.uniq

    5.times do
      sku.images << Image.create(file: setup_image(:product))
    end

    sku.save!

  end

  def create_variant_option(product)

    # We use this variable because it's impossible to count variations
    # It's embedded into product so not saved immediatly.
    @variant_options = 0 if @variant_options.nil?
    @variant_options += 1

    num     = VariantOption.count + @variant_options
    name    = "Variation #{num}"
    choices = rand(1..5)

    puts "We create #{name}"

    variant_option = VariantOption.new(:name => "Variation #{num}", :product => product)
    choices.times do |time|
      choice = VariantOption.new(:parent => variant_option, :name => "Choice #{time}")
      choice.save!
    end

    variant_option.save!
    product.save!

  end

  def create_product(shop)

    num           = Product.count + 1
    num_variants  = rand(1..4)
    num_skus      = rand(1..5)
    category_slug = [:food, :cosmetics, :fashion, :medicine, :household].sample
    approved      = Time.now.utc

    name          = "Product #{num}"
    brand         = "Brand #{num}"
    hs_code       = 12212121

    puts "We create #{name} (#{category_slug})"

    product = Product.new(
        :name     => name,
        :desc     => "#{Faker::Lorem.paragraph(1)}\n\n#{Faker::Lorem.paragraph(2)}",
        :cover    => setup_image(:banner),
        :brand    => brand,
        :shop     => shop,
        :hs_code  => hs_code,
        :approved => approved,
    )

    # Should be a one category system
    product.category_ids << Category.where(:slug => category_slug.to_s).first.id

    # We had the duty category
    product.duty_category = DutyCategory.all.sample

    num_variants.times do |time|
      create_variant_option(product)
      product.save!
    end

    num_skus.times do
      create_sku(product)
    end

    shop.products << product
    shop.save!

  end

  def create_shop(shopkeeper)

    num            = Shop.count + 1
    name           = "Shop #{num}"
    min_total      = num * 10
    approved       = Time.now.utc
    agb            = true
    status         = true
    bg_merchant_id = "1024-TEST"
    seals = {
      :seal0 => setup_image(:seal),
      :seal1 => setup_image(:seal),
      :seal2 => setup_image(:seal),
      :seal3 => setup_image(:seal),
      :seal4 => setup_image(:seal),
      :seal5 => setup_image(:seal),
      :seal6 => setup_image(:seal),
      :seal7 => setup_image(:seal)
    }

    puts "We create #{name}"

    Shop.create!({
        :name           => name,
        :desc           => Faker::Lorem.paragraph,
        :german_essence => Faker::Lorem.paragraph(7),
        :logo           => setup_image(:logo),
        :banner         => setup_image(:banner),
        :min_total      => min_total,
        :shopkeeper     => shopkeeper,
        :founding_year  => random_year,
        :register       => 12345678,
        :philosophy     => Faker::Lorem.paragraph(7),
        :stories        => Faker::Lorem.paragraph(7),
        :tax_number     => '12345678',
        :ustid          => 'DE123456789',
        :shopname       => name,
        :mail           => shopkeeper.email,
        :approved       => approved,
        :agb            => agb,
        :status         => status,
        :bg_merchant_id => bg_merchant_id,
    }.merge(seals))



  end

  def create_shop_address(shop)

    type = 'both'
    country = 'DE'

    puts "We create a shop address"

    address = Address.new(
      :number   => rand(1..20),
      :street   => Faker::Address.street_name,
      :city     => Faker::Address.city,
      :province => Faker::Address.state,
      :zip      => Faker::Address.zip_code,
      :type     => type,
      :fname    => shop.shopkeeper.fname,
      :lname    => shop.shopkeeper.lname,
      :company  => shop.shopname,
      :country  => country,
    )

    shop.addresses << address
    shop.save!

  end

  def create_user(symbol=:customer)

    num = User.where(:role => symbol).count + 1
    name = symbol.to_s.capitalize

    if [true, false].sample
      tourist_guide = Faker::Company.name.downcase.to_sym
    end

    puts "Let's create #{symbol} N#{num} ..."

    User.create!(
      :fname                 => name,
      :lname                 => "N#{num}",
      :gender                => ['f', 'm'].sample,
      :email                 => "#{symbol}#{num}@#{symbol}.com",
      :password              => '12345678',
      :password_confirmation => '12345678',
      :role                  => symbol,
      :referrer_id          => tourist_guide,
      :tel                   => Faker::PhoneNumber.phone_number,
      :mobile                => Faker::PhoneNumber.cell_phone,
      :birth                 => random_date,
    )

  end

  def random_date
    Time.at(rand * Time.now.utc.to_i).strftime("%F")
  end

  def random_year
    Time.at(rand * Time.now.utc.to_i).year
  end

  def random_product
    Product.all.sample
  end

  def random_file(folder_path)
    Dir["#{folder_path}/*"].shuffle.first unless Dir["#{folder_path}/*"].empty?
  end

  def setup_customer(customer)
  end

  def setup_guide(user)
    user.update(email: "guide@guide.com")
    referrer = Referrer.create(user: user)
    coupon = Coupon.create_referrer_coupon(referrer)
    setup_order(coupon: coupon)
  end

  def setup_orders(coupon: nil)
    # - generate random sku
    # - create an order with the sku shop
    # - insert the sku into the order as order item
    # - make a fake payment
    # - refresh payment status
    sku = random_product.skus.first
    order = Order.create(shop: sku.shop, logistic_partner: Setting.instance.logistic_partner, coupon: coupon)
    OrderMaker.new(order).sku(sku).refresh!(quantity)
    setup_successful_order_payment(order: order)
    refresh_status_from!(order_payment)
    order.refresh_status_from!(order_payment)
  end

  def setup_successful_order_payment(order: nil)
    OrderPayment.create(
      request_id: "RAND",
      merchant_id: "RAND",
      amount_eur: order.end_price,
      status: :success,
      amount_cny: order.end_price.in_euro.to_yuan,
      transaction_type: :purchase,
      payment_method: :wechatpay,
      origin_currency: "CNY",
      order_id: order,
      user_id: order.customer
    )
  end

  def active_wirecard(shop, num)
    shop.wirecard_status = :active
    shop.save
    if num == 2
      payment_methods = [:creditcard, :upop]
    else
      payment_methods = [:creditcard]
    end
    payment_methods.each do |payment_method|
    PaymentGateway.create({
        :shop_id => shop.id,
        :payment_method => payment_method,
        :provider => :wirecard,
        :merchant_id => WIRECARD_DEMO[payment_method][:merchant_id],
        :merchant_secret => WIRECARD_DEMO[payment_method][:merchant_secret]
      })
    end
    # ensure default payment methods
    [:alipay, :wechatpay].each do |payment_method|
      payment_gateway = PaymentGateway.where(shop_id: shop.id, payment_method: payment_method).first || PaymentGateway.new
      payment_gateway.shop_id = shop.id
      payment_gateway.provider = payment_method
      payment_gateway.payment_method = payment_method
      payment_gateway.merchant_id = nil
      payment_gateway.merchant_secret = nil
      payment_gateway.save
    end
  end

  def setup_shopkeeper(shopkeeper, args={})

    num_products = args[:num_products] || rand(0..20)

    shop = create_shop(shopkeeper)
    create_shop_address(shop)

    # wirecard
    active_wirecard(shop, rand(1..2))

    num_products.times do |time|
      create_product(shop)
    end

  end

  def setup_packageset

    num = PackageSet.count
    shop = Shop.all.shuffle.first

    puts "Let's create PackageSet N#{num} ..."

    package_set = PackageSet.create({
      :shop => shop,
      :name => "Package Set #{num}",
      :desc => Faker::Lorem.paragraph,
      :long_desc => Faker::Lorem.paragraph(3),
      :cover => setup_image(:banner),
      :details_cover => setup_image(:banner),
      :casual_price => Faker::Number.decimal(2),
      :shipping_cost => Faker::Number.decimal(1)
    })

    3.times do
      sku = shop.products.has_available_sku.all.shuffle.first&.skus.first
      package_set.package_skus.create({
        :sku_id => sku.id,
        :product => sku.product,
        :quantity => Faker::Number.between(1, 3),
        :price => Faker::Number.decimal(2),
        :taxes_per_unit => Faker::Number.decimal(1),
      })
    end

    4.times do
      package_set.images.create(file: setup_image(:product))
    end

  end

  def setup_documentation(section)

    content_type = "application/#{section}"
    folder = File.join(Rails.root, 'public', 'samples', 'documentations', section.to_s)
    file = random_file folder
    if file.nil?
      puts "Impossible to get random documentation, empty folder `#{folder}`"
      puts "We stop the process."
      exit
    end

    file_name = file.split('/').last

    file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(file, 'rb'))
    file.original_filename = file_name
    file.content_type = content_type
    file

  end

  def setup_image(section)

    content_type = 'image/jpeg'
    folder = File.join(Rails.root, 'public', 'samples', 'images', section.to_s)
    file = random_file folder
    if file.nil?
      puts "Impossible to get random image, empty folder `#{folder}`"
      puts "We stop the process."
      exit
    end

    file_name = file.split('/').last

    file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(file, 'rb'))
    file.original_filename = file_name
    file.content_type = content_type
    file

  end

end
