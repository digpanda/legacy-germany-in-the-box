require 'csv'

class Shopkeeper::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_reader :order

  def show
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
      end
    end
  end

  def start_process

    #
    # We start by processing into a CSV file
    #
  
    # Barcode ID
    barcode_id = order.border_guru_shipment_id
    # Merchant ID
    borderguru_merchant_id = order.shop.bg_merchant_id || "1026-TEST"
    # Country
    country = "DE"

    csv_output = CSV.generate do |csv|

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

      order.order_items.each do |order_item|

        csv << [

          barcode_id,
          borderguru_merchant_id,
          country,

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

    #
    # We generate the file itself and store it into our server
    # Filename : YYYMMDD_SUBMERCHANTID
    # 
    begin

      directory = "public/uploads/borderguru/#{order.shop.id}"
      formatted_date = Time.now.strftime("%Y%m%d")

      require 'fileutils'
      FileUtils::mkdir_p directory
      file = File.open("public/uploads/borderguru/#{order.shop.id}/#{formatted_date}_#{borderguru_merchant_id}.csv", "w")
      file.write(csv_output)

    rescue IOError => e
      flash[:error] = "A problem occured while preparing the order to our service."
      redirect_to(:back) and return
    ensure
      file.close unless file.nil?
    end

    #
    # We transfer the information to BorderGuru
    # We could avoid opening the file twice but it's a double process.
    # 

    require 'net/ftp'
    ftp = Net::FTP.new
    ftp.connect('84.200.54.181', '1348')  # here you can pass a non-standard port number
    ftp.login('ftp','doNotAllowRetryMoreThan019')
    #ftp.passive = true  # optional, if PASV mode is required

    file = File.open("public/uploads/borderguru/#{order.shop.id}/#{formatted_date}_#{borderguru_merchant_id}.csv", "w")
    ftp.putbinaryfile(file)
    ftp.quit()

=begin
    file = File.open("public/uploads/borderguru/#{order.shop.id}/#{formatted_date}_#{borderguru_merchant_id}.csv", "w")
    ftp = Net::FTP.new('84.200.54.181')
    ftp.login(user = "***", passwd = "doNotAllowRetryMoreThan019")
    ftp.putbinaryfile(file.read, File.basename(file.original_filename))
    ftp.quit()
=end

    #
    # We don't forget to change status of orders and such
    # Only if everything was a success
    #
    order.status = :custom_processing
    #
    # We go back now
    #
    flash[:success] = "Your order is being processed by our partner."
    redirect_to(:back) and return

  end

  private

  def set_order
    @order ||= Order.find(params[:id] || params[:order_id])
  end
end