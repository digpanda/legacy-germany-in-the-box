#require 'border_guru_ftp'

class Tasks::Cron::TransmitPickupOrdersToHermes

  CSV_ENCODE = "UTF-8"
  MEAN_OF_TRANSPORT = "Pakete"
  DESTINATION = "FRA"
  MINIMUM_EMAIL_SENDING_DATE = 80.hours.from_now

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

        orders = sendable_orders(orders)
        next unless orders.any?

        data = email_datas(shop, shopkeeper, orders)
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

  # those params should be put into classes and be global
  # same for most of the private methods here, refacto needed
  def email_datas(shop, shopkeeper, orders)
    {
      :company_name => shop.name,
      :contact_name => shopkeeper.full_name,
      :contact_phone => shopkeeper.mobile,
      :number_of_packages => orders.length,
      :total_weight_in_kg => total_weight(orders),
      :mean_of_transport => MEAN_OF_TRANSPORT,
      :number_of_mean_of_transport => orders.length, # alias of number of packages
      :total_volume => total_volume(orders),
      :pickup_address => shop.billing_address.decorate.full_address,
      :destination => DESTINATION,
      :orders_barcodes => barcodes(orders),
      :orders_descriptions => descriptions(orders)
    }
  end

  def sendable_orders(orders)
    orders.select do |order|
      email_sendable?(order)
    end
  end

  def total_weight(orders)
    orders.reduce(0) { |acc, order| acc + order.total_weight }
  end

  def total_volume(orders)
    orders.reduce(0) { |acc, order| acc + order.total_volume }
  end

  def barcodes(orders)
    orders.reduce([]) { |acc, order| acc << order.border_guru_shipment_id }
  end

  def descriptions(orders)
    orders.reduce([]) { |acc, order| acc << order.desc }
  end

  def email_sendable?(order)
    (order.minimum_sending_date < MINIMUM_EMAIL_SENDING_DATE) && !order.hermes_pickup_email_sent_at
  end

  def orders_by_shop
    @orders_by_shop ||= orders.group_by(&:shop_id).values
  end

end