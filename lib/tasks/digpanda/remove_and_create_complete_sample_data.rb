require 'faker'

class RemoveAndCreateCompleteSampleData

  def initialize

    #
    # We first remove absolutely everything
    #
    puts "We remove all users"
    User.delete_all
    puts "We remove all shops"
    Shop.delete_all

    puts "We set the locale to Germany"
    I18n.locale = :de
    Faker::Config.locale = 'de'

    puts "We create the base customer, shopkeeper, admin"
    base_customer = create_user(:customer)
    base_shopkeeper = create_user(:shopkeeper)
    base_admin = create_user(:admin)

    shop = create_shop(base_shopkeeper)
    product = create_product(shop)

    Rails.cache.clear

    puts "End of process."

  end

  private

  def create_sku(product)

    price = 10
    quantity = 5
    num_options = rand(1..3)
    weight = 0.5 # kg
    space_length = 1.0
    space_width = 2.0
    space_height = 3.0

    sku = Sku.new(
      :price => 10,
      :product => product,
      :quantity => 5,
      :weight => weight,
      :space_length => space_length,
      :space_width => space_width,
      :space_height => space_height
    )

    num_options.times do |time|
      sku.option_ids << product.options.shuffle.first.id.to_s
    end
    sku.option_ids.uniq # should be managed via model directly ?

    4.times do |time|
      instance_variable_set("sku.img#{time}", setup_image(:product))
    end

    sku.save!

  end

  def create_variant_option(product)

    num = VariantOption.count + 1
    name = "Variation #{num}"
    choices = rand(10)

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

    num = Product.count + 1
    num_variants = rand(1..10)

    name = "Product #{num}"
    brand = "Brand #{num}"
    hs_code = 12212121

    puts "We create #{name}"

    product = Product.new(
        :name => name,
        :desc => Faker::Lorem.paragraph,
        :cover => 'https://images2.dawandastatic.com/23/c2/61/cf/40/44/4d/62/a4/30/1b/3c/00/7b/12/fe/product_l.JPEG',
        :brand => brand,
        :shop => shop,
        :hs_code => hs_code
    )

    num_variants.times do |time|
      create_variant_option(product)
    end
    product.save!

    create_sku(product)

    shop.products << product
    shop.save!

  end

  def create_shop(shopkeeper)

    num = Shop.count + 1
    name = "Shop #{num}"
    min_total = num * 10

    puts "We create #{name}"

    Shop.create!(
        :name          => name,
        :desc          => Faker::Lorem.paragraph,
        #:logo         => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-logo.jpg'),
        #:banner       => create_upload_from_image_file(Shop.name.downcase, 'herz-buffet-banner.jpg'),
        :min_total     => min_total,
        :shopkeeper    => shopkeeper,
        :founding_year => random_year,
        :register      => 12345678,
        :philosophy    => Faker::Lorem.paragraph,
        :stories       => Faker::Lorem.paragraph,
        :agb           => true,
        :tax_number    => '12345678',
        :ustid         => 'DE123456789',
        :shopname      => name,
        :fname         => shopkeeper.fname,
        :lname         => shopkeeper.lname,
        :tel           => shopkeeper.mobile,
        :mail          => shopkeeper.email
    );

  end

  def create_user(symbol=:customer)
    
    num = User.where(:role => symbol).count + 1
    name = symbol.to_s.capitalize

    puts "Let's create #{symbol} N°#{num} ..."

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
      :birth => random_date,
    )

  end

  def random_date
    Time.at(rand * Time.now.to_i).strftime("%F")
  end

  def random_year
    Time.at(rand * Time.now.to_i).year
  end

  def get_random_file(folder_path)
    Dir["#{folder_path}/*"].shuffle.first
  end

  #
  # creates image upload file
  #
  def setup_image(section)

    content_type = 'image/jpeg'

    file = get_random_file File.join(Rails.root, 'public', 'samples', 'images', section)

    file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(file)), 'rb'))
    file.original_filename = image_name
    file.content_type = content_type
    file

  end

end
