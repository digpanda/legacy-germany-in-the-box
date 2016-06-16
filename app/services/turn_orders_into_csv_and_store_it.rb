require 'fileutils'
require 'csv'

class TurnOrdersIntoCsvAndStoreIt

  attr_reader :orders

  def initialize(orders)

    @orders ||= orders
    csv_output = generate_borderguru_csv(orders)
    store_csv_file(csv_output)

  end

  private

  def borderguru_params
    @borderguru_params ||= {
      :merchant_id => order.shop.bg_merchant_id || "1026-TEST",
      :barcode_id => order.border_guru_shipment_id,
      :country => "DE"
    }
  end

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

            borderguru_params[:barcode_id],
            borderguru_params[:merchant_id],
            borderguru_params[:country],

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

    if orders.empty?
      return false
    end

    #
    # We generate the file itself and store it into our server
    # Filename : YYYMMDD_SUBMERCHANTID
    # 
    begin

      directory = "public/uploads/borderguru/#{orders.first.shop.id}"
      formatted_date = Time.now.strftime("%Y%m%d")

      FileUtils::mkdir_p directory
      file = File.open("#{directory}/#{formatted_date}_#{borderguru_params[:merchant_id]}.csv", "w")
      file.write(csv_output)
      
    rescue IOError => e
      return false
    ensure
      file.close unless file.nil?
    end

    "#{directory}/#{formatted_date}_#{borderguru_params[:merchant_id]}.csv"

  end

end
