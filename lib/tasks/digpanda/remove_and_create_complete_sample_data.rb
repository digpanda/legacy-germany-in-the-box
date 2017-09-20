require 'faker'

class Tasks::Digpanda::RemoveAndCreateCompleteSampleData
  def initialize
  end

  def perform

    # NOTE Reset the correct migration
    # This is a manual manipulation on the database.
    # If something fails in the middle please get back the correct version from staging
    versions = []
    db = Mongoid::Clients.default
    collection = db[:data_migrations]
    collection.find.each do |data_migration|
      versions << data_migration["version"]
    end

    #
    # We first remove absolutely everything
    #
    puts "We purge the whole database ..."
    Mongoid.purge!

    # NOTE Now we get back the previously purged
    # version of the migration state
    versions.each do |version|
      collection.insert_one(version: version)
    end

    puts 'We set the locale to Germany'
    I18n.locale = :de
    Faker::Config.locale = 'de'

    puts 'We repopulate the categories from another rake task'
    puts '---'
    Tasks::Digpanda::RemoveAndCreateDutyCategories.new
    Tasks::Digpanda::RemoveAndCreateUiCategories.new
    puts '---'

    puts 'We refresh the duty category taxes'
    puts '---'
    Tasks::Digpanda::RefreshDutyCategoriesTaxes.new
    puts '---'

    puts 'We refresh the shipping rates'
    puts '---'
    Tasks::Digpanda::RefreshShippingRates.new
    puts '---'

    puts 'We create the customers, guides, shopkeepers, admins'

    25.times { setup_customer create_user(:customer) }
    3.times { create_user(:admin) }

    10.times { setup_shopkeeper create_user(:shopkeeper) }
    8.times { setup_package_set }
    2.times { setup_package_set(shop: Shop.first) } # same shops for package set

    convert_product_without_first_sku_left(random_product)
    convert_product_with_documentation_attached(random_product)

    # at the end we create tourist guides
    # they will take random skus to compose fake orders
    Setting.instance.update(default_coupon_discount: 10.00)
    1.times { setup_guide create_user(:customer) }

    add_orders_to_customers

    Rails.cache.clear

    puts 'End of process.'
  end

  private

    def add_orders_to_customers
      User.where(role: :customer).each do |user|
        # we assign orders to each customer
        3.times do
          setup_order(user: user)
        end
      end
    end

    def convert_product_with_documentation_attached(product)
      puts "We convert #{product.name} to a `with_documentation_attached`"
      product.name += ' WITH DOCUMENTATION'
      product.skus.first.data = Faker::Lorem.paragraph
      product.skus.first.attach0 = setup_documentation(:pdf)
      product.save!
    end

    def convert_product_without_first_sku_left(product)
      puts "We convert #{product.name} to a `without_first_sku_left`"
      product.name += ' NO FIRST SKU'
      product.desc = "The price of the first Sku is #{product.skus.first.price} and shouldn't appear."
      product.skus.first.quantity = 0
      product.save!
    end

    def create_pricey_sku(product)
      create_sku(product, price: 500)
    end

    def create_big_sku(product)
      create_sku(product,
        weight: 2.0,
        space_length: 10,
        space_width: 20,
        space_height: 30
        )
    end

    def create_sku(product, args = {})
      price        = args[:price] || (2 * Product.count) + (product.skus.count * 10)
      quantity     = args[:quantity] || rand(10..30)
      num_options  = args[:num_options] || rand(1..5)
      weight       = args[:weight] || 0.5
      space_length = args[:space_length] || 1.0
      space_width  = args[:space_width] || 2.0
      space_height = args[:space_height] || 3.0

      sku = Sku.new(
        price: price,
        product: product,
        quantity: quantity,
        weight: weight,
        space_length: space_length,
        space_width: space_width,
        space_height: space_height,
        data: "#{Faker::Lorem.paragraph(1)}\n\n#{Faker::Lorem.paragraph(2)}"
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

      variant_option = VariantOption.new(name: "Variation #{num}", product: product)
      choices.times do |time|
        choice = VariantOption.new(parent: variant_option, name: "Choice #{time}")
        choice.save!
      end

      variant_option.save!
      product.save!
    end

    def create_product(shop)
      num           = Product.count + 1
      num_variants  = rand(1..4)
      num_skus      = rand(1..5)
      category_slug = [:food, :cosmetics, :fashion, :medicine, :household, :luxury].sample
      approved      = Time.now.utc

      name          = "Product #{num}"
      hs_code       = 12212121

      puts "We create #{name} (#{category_slug})"

      product = Product.new(
        name: name,
        desc: "#{Faker::Lorem.paragraph(1)}\n\n#{Faker::Lorem.paragraph(2)}",
        cover: setup_image(:banner),
        referrer_rate: 10.00,
        brand: Brand.create(name: "Brand #{num}"),
        shop: shop,
        hs_code: hs_code,
        approved: approved
      )

      # Should be a one category system
      product.category_ids << Category.where(slug_name: category_slug.to_s).first.id

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
      seals = {
        seal0: setup_image(:seal),
        seal1: setup_image(:seal),
        seal2: setup_image(:seal),
        seal3: setup_image(:seal),
        seal4: setup_image(:seal),
        seal5: setup_image(:seal),
        seal6: setup_image(:seal),
        seal7: setup_image(:seal)
      }

      puts "We create #{name}"

      Shop.create!({
        name: name,
        desc: Faker::Lorem.paragraph,
        german_essence: Faker::Lorem.paragraph(7),
        logo: setup_image(:logo),
        banner: setup_image(:banner),
        min_total: min_total,
        shopkeeper: shopkeeper,
        founding_year: random_year,
        register: 12345678,
        philosophy: Faker::Lorem.paragraph(7),
        stories: Faker::Lorem.paragraph(7),
        tax_number: '12345678',
        ustid: 'DE123456789',
        shopname: name,
        mail: shopkeeper.email,
        approved: approved,
        agb: agb,
        status: status,
      }.merge(seals))
    end

    def create_user_address(user)

      puts 'We create a user address'

      address = Address.new(
      fname:       '薇',
      lname:       '李',
      additional:  '309室',
      street:      '华江里',
      number:      '21',
      zip:         '300222',
      city:        '天津',
      country:     'CN',
      mobile:      '13802049778',
      province:    '天津',
      district:    '和平区',
      pid:         '11000019790225207X'
      )


      user.addresses << address
      user.save!
    end

    def create_shop_address(shop)
      type = 'both'
      country = 'DE'

      puts 'We create a shop address'

      address = Address.new(
        number: rand(1..20),
        street: Faker::Address.street_name,
        city: Faker::Address.city,
        province: Faker::Address.state,
        zip: Faker::Address.zip_code,
        type: type,
        fname: shop.shopkeeper.fname,
        lname: shop.shopkeeper.lname,
        company: shop.shopname,
        country: country
      )

      shop.addresses << address
      shop.save!
    end

    def create_user(symbol = :customer)
      num = User.where(role: symbol).count + 1
      name = symbol.to_s.capitalize

      if [true, false].sample
        tourist_guide = Faker::Company.name.downcase.to_sym
      end

      puts "Let's create #{symbol} N#{num} ..."

      user = User.create!(
        fname: name,
        lname: "N#{num}",
        gender: ['f', 'm'].sample,
        email: "#{symbol}#{num}@#{symbol}.com",
        password: '12345678',
        password_confirmation: '12345678',
        role: symbol,
        referrer: tourist_guide,
        mobile: Faker::PhoneNumber.cell_phone,
        birth: random_date,
      )

    end

    def random_date
      Time.at(rand * Time.now.utc.to_i).strftime('%F')
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

    def random_category
      Category.all.sample
    end

    def setup_customer(customer)
      create_user_address(customer)
    end

    def setup_guide(user)
      user.update(email: 'guide@guide.com')
      referrer = Referrer.create(user: user)
      coupon = Coupon.create_referrer_coupon(referrer)
      setup_order(coupon: coupon)
    end

    # - generate random sku
    # - create an order with the sku shop
    # - insert the sku into the order as order item
    # - make a fake payment
    # - refresh payment status
    def setup_order(coupon: nil, user: nil)
      sku = random_product.skus.first
      user = user || create_user(:customer)

      order = Order.create(
                    user: user,
                    shop: sku.product.shop,
                    logistic_partner: Setting.instance.logistic_partner,
                    coupon: coupon,
                    )

      OrderMaker.new(nil, order).sku(sku).refresh!(1)

      order_payment = fake_successful_order_payment(order: order)
      order.refresh_status_from(order_payment)
    end

    def fake_successful_order_payment(order: nil)
      OrderPayment.create(
        request_id: 'RAND',
        merchant_id: 'RAND',
        amount_eur: order.end_price,
        status: :success,
        amount_cny: order.end_price.in_euro.to_yuan,
        transaction_type: :purchase,
        payment_method: :wechatpay,
        origin_currency: 'CNY',
        order: order,
        user: order.user
      )
    end

    def active_payment_gateways(shop)
      # ensure default payment methods
      [:alipay, :wechatpay].each do |payment_method|
        payment_gateway = PaymentGateway.where(shop_id: shop.id, payment_method: payment_method).first || PaymentGateway.new
        payment_gateway.shop_id = shop.id
        payment_gateway.provider = payment_method
        payment_gateway.payment_method = payment_method
        payment_gateway.save
      end
    end

    def setup_shopkeeper(shopkeeper, args = {})
      num_products = args[:num_products] || rand(0..20)

      shop = create_shop(shopkeeper)
      create_shop_address(shop)

      active_payment_gateways(shop)

      num_products.times do |time|
        create_product(shop)
      end
    end

    def setup_package_set(shop: nil)
      num = PackageSet.count
      shop = Shop.all.shuffle.first unless shop

      puts "Let's create PackageSet N#{num} ..."

      package_set = PackageSet.create(
        shop: shop,
        name: "Package Set #{num} (Shop #{shop.name})",
        desc: Faker::Lorem.paragraph,
        long_desc: Faker::Lorem.paragraph(3),
        cover: setup_image(:banner),
        category: random_category,
        details_cover: setup_image(:banner),
        casual_price: Faker::Number.decimal(2),
        shipping_cost: Faker::Number.decimal(1)
      )

      3.times do
        sku = shop.products.has_available_sku.all.shuffle.first&.skus&.first
        if sku
          package_set.package_skus.create(
            sku_id: sku.id,
            product: sku.product,
            quantity: Faker::Number.between(1, 3),
            price: Faker::Number.decimal(2),
            taxes_per_unit: Faker::Number.decimal(1)
          )
        end
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
        puts 'We stop the process.'
        exit
      end

      file_name = file.split('/').last

      file = ActionDispatch::Http::UploadedFile.new(tempfile: File.open(file, 'rb'))
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
        puts 'We stop the process.'
        exit
      end

      file_name = file.split('/').last

      file = ActionDispatch::Http::UploadedFile.new(tempfile: File.open(file, 'rb'))
      file.original_filename = file_name
      file.content_type = content_type
      file
    end
end
