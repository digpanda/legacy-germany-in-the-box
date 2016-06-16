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
    csv_file_path = TurnOrderIntoCsvAndStoreIt.perform({

      :order => order

    })

    if csv_file_path == false
      flash[:error] = "A problem occured while preparing your order in our server. Please try again."
      redirect_to(:back) and return
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