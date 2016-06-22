require 'fileutils'
require 'csv'

#
# Once per day we have to turn the orders which were approved by the shopkeepers
# Into a series of CSVs files.
# This will be stored locally.
#
class TurnOrdersIntoCsvAndStoreIt < BaseService

  attr_reader :orders, :shop, :borderguru, :borderguru_merchant_id, :borderguru_local_directory

  def initialize(shop, orders)
    @orders = orders
    @shop = shop
    @borderguru = Rails.application.config.border_guru
    @borderguru_local_directory = Rails.root.join.borderguru[:ftp][:local_directory]
    @borderguru_merchant_id = shop.bg_merchant_id || "1026-TEST-#{Random.rand(1000)}"
  end

  def perform
    csv_output = generate_borderguru_csv(orders)
    store_csv_file(csv_output)
  end

  private

  def generate_borderguru_csv(orders)

    CSV.generate do |csv|

      csv << [

        'Barcode ID',
        'Merchant ID',
        'Country ID',
        'Item ID',
        'HS Code',
        'Description',
        'Weight (g)',
        'Price',
        'Currency'

      ]

      orders.each do |order|

        order.order_items.each do |order_item|

          csv << [

            order.border_guru_shipment_id,
            borderguru_merchant_id,
            borderguru[:products][:origin],

            # Item ID
            order_item.sku.id,
            # HS Code
            order_item.product.hs_code,
            # Description
              order_item.product.decorate.clean_desc(240), # check if including spaces
            # Weight : current_order_item.weight
              order_item.weight, # check it's in g
            # Price
              order_item.price, # check that to be sure
            # Currency
            'EUR'

          ]

        end

      end

    end

  end

  def store_csv_file(csv_output)

    return return_with(:error, "No order to place.") if orders.empty?

    #
    # We generate the file itself and store it into our server
    # Filename : YYYMMDD_SUBMERCHANTID
    # 
    begin

      FileUtils.mkdir_p(borderguru_local_directory) unless File.directory?(borderguru_local_directory)

      directory = "#{borderguru_local_directory}#{shop.id}"
      formatted_date = Time.now.strftime("%Y%m%d")

      FileUtils::mkdir_p directory

      file = File.open("#{directory}/#{formatted_date}_#{borderguru_merchant_id}.csv", "w")
      file.write(csv_output)

      return_with(:success)
      
    rescue IOError => e
      return_with(:error, e)
    ensure
      file.close unless file.nil?
    end
  end

end
