require 'faker'

class Tasks::Digpanda::RemoveAndCreateCompleteSampleData

  def initialize
  end

  def perform

    #
    # We first remove absolutely everything
    #
    puts "We remove all users"
    User.delete_all
    puts "We remove all shops"
    Shop.delete_all
    puts "We remove all products"
    Product.delete_all
    puts "We remove all the orders / order payments"
    Order.delete_all
    OrderPayment.delete_all
    puts "We remove all the orders items"
    OrderItem.delete_all
    puts "We remove all addresses"
    Address.delete_all

    puts "We set the locale to Germany"
    I18n.locale = :de
    Faker::Config.locale = 'de'

    puts "We repopulate the categories from another rake task"
    puts "---"
    Tasks::Digpanda::RemoveAndCreateDutyCategories.new
    Tasks::Digpanda::RemoveAndCreateUiCategories.new
    puts "---"

    puts "We create the customers, shopkeepers, admins"

    10.times { setup_customer create_user(:customer) }
    3.times { create_user(:admin) }

    10.times { setup_shopkeeper create_user(:shopkeeper) }
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
      :space_height => space_height
    )

    num_options.times do |time|
      sku.option_ids << product.options.sample.suboptions.sample.id.to_s
    end
    sku.option_ids.uniq

    # This is terrible and we should never have to do this kind of shit.
    # Should be changed very soon.
    sku.img0 = setup_image(:product)
    sku.img1 = setup_image(:product)
    sku.img2 = setup_image(:product)
    sku.img3 = setup_image(:product)

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
    approved      = Time.now

    name          = "Product #{num}"
    brand         = "Brand #{num}"
    hs_code       = 12212121

    puts "We create #{name} (#{category_slug})"

    product = Product.new(
        :name     => name,
        :desc     => Faker::Lorem.paragraph,
        :cover    => setup_image(:banner),
        :brand    => brand,
        :shop     => shop,
        :hs_code  => hs_code,
        :approved => approved,
    )

    # Should be a one category system
    product.category_ids << Category.where(:slug => category_slug.to_s).first.id

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
    approved       = Time.now
    agb            = true
    status         = true
    bg_merchant_id = "1024-TEST"

    puts "We create #{name}"

    Shop.create!(
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
        :fname          => shopkeeper.fname,
        :lname          => shopkeeper.lname,
        :tel            => shopkeeper.mobile,
        :mail           => shopkeeper.email,
        :approved       => approved,
        :agb            => agb,
        :status         => status,
        :bg_merchant_id => bg_merchant_id,
    );

  end

  def create_shop_address(shop)

    type = 'both'
    country = 'DE'

    puts "We create a shop address"

    address = Address.create(

      :number   => '670000',
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

    address.shop = shop
    address.save!

  end

  def create_user(symbol=:customer)

    num = User.where(:role => symbol).count + 1
    name = symbol.to_s.capitalize

    puts "Let's create #{symbol} N#{num} ..."

    User.create!(
      :fname                 => name,
      :lname                 => "N#{num}",
      :gender                => ['f', 'm'].sample,
      :username              => "#{name}#{num}",
      :email                 => "#{symbol}#{num}@#{symbol}.com",
      :password              => '12345678',
      :password_confirmation => '12345678',
      :role                  => symbol,
      :tel                   => Faker::PhoneNumber.phone_number,
      :mobile                => Faker::PhoneNumber.cell_phone,
      :birth                 => random_date,
    )

  end

  def random_date
    Time.at(rand * Time.now.to_i).strftime("%F")
  end

  def random_year
    Time.at(rand * Time.now.to_i).year
  end

  def random_product
    Product.all.sample
  end

  def random_file(folder_path)
    Dir["#{folder_path}/*"].shuffle.first unless Dir["#{folder_path}/*"].empty?
  end

  def setup_customer(customer)


  end

  def setup_shopkeeper(shopkeeper, args={})

    num_products = args[:num_products] || rand(0..20)

    shop = create_shop(shopkeeper)
    create_shop_address(shop)

    num_products.times do |time|
      create_product(shop)
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
