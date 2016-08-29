#require 'border_guru_ftp'

class Tasks::Cron::TransmitPickupOrdersToHermes

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the current orders ..."

    hack = Order.where(border_guru_shipment_id: "14721405156233822").first
    if hack
      hack.minimum_sending_date = nil
      hack.save
      devlog "HACK ORDER ID #{hack.id}"
    end

    @orders = Order.where(status: :custom_checking).all
  end

  def perform

    unless orders.length.zero?
      begin
        BorderGuruEmail.transmit_orders(orders)
      rescue BorderGuruEmail::Error => exception
        devlog "A problem occured while transmitting the orders (#{exception.message})."
        return
      end
    end

    devlog "Process finished."
  end

  def devlog(content)
    BorderGuruEmail.log(content)
  end

end
