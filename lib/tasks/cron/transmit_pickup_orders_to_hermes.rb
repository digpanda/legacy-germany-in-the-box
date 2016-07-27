#require 'border_guru_ftp'

class Tasks::Cron::TransmitPickupOrdersToHermes

  CSV_ENCODE = "UTF-8"
  MEAN_OF_TRANSPORT = "Pakete"

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the current orders ..."
    @orders = Order.where(status: :custom_checking).all
  end

  def perform

    unless orders.length.zero?

      # group by shop id
      # for each shop id we will send one email with all the informations
      # we only calculate from the orders which will be shippable the day after from 10am (we can safely say 18h later)
      # we group them calculate things and send the email
      
      orders_by_shop.each do |orders|

        shop = orders.first.shop.decorate
        shopkeeper = shop.shopkeeper.decorate

        # only one shop and only the email sendable orders
        orders = orders.select do |order|
          email_sendable?(order)
        end

        data = {

          :company_name => shop.name,
          :contact_name => shopkeeper.full_name,
          :contact_phone => shopkeeper.mobile,
          :number_of_packages => orders.length,
          :total_weight_in_kg => orders.reduce(0) { |acc, order| acc + order.total_weight },
          :mean_of_transport => MEAN_OF_TRANSPORT,
          :number_of_mean_of_transport => orders.length, # alias of number of packages
          :total_volume => orders.reduce(0) { |acc, order| acc + order.total_volume },
          :pickup_address => shop.billing_address.decorate.full_address,
          :destination => 'FRA',
          :orders_barcodes => orders.reduce([]) { |acc, order| acc << order.border_guru_shipment_id },
          :orders_descriptions => orders.reduce([]) { |acc, order| acc << order.desc }

        }

        csv = BorderGuruFtp::TransferOrders::Makers::Generate.new(orders).to_csv.encode(CSV_ENCODE)
        HermesMailer.notify(shopkeeper.email, data, csv).deliver_now

        # TODO : update transmitted orders (hermes_pickup_email_sent_at)

      end

    end

    devlog "Process finished."
  end

  def devlog(content)
    #BorderGuruFtp.log(content) <-- to replace approprietly
  end

  private

  def email_sendable?(order)
    # TODO : put back to 24h when done
    (order.minimum_sending_date < 80.hours.from_now) && !order.hermes_pickup_email_sent_at
  end

  def orders_by_shop
    @orders_by_shop ||= orders.group_by(&:shop_id).values
  end

end