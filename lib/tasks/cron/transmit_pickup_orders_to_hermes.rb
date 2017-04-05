#require 'border_guru_ftp'

class Tasks::Cron::TransmitPickupOrdersToHermes

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the current orders ..."
    @orders = Order.where(status: :custom_checking).all
  end

  def perform

    if Setting.instance.logistic_partner == :borderguru

      unless orders.length.zero?
        begin
          devlog "We will transmit #{orders.length}` orders now."
          BorderGuruEmail.transmit_orders(orders)
        rescue BorderGuruEmail::Error => exception
          devlog "A problem occured while transmitting the orders (#{exception.message})."
          return
        end
      end

    else
      devlog "Logistic partner is not BorderGuru, we skip the processing."
    end

    devlog "Process finished."
  end

  def devlog(content)
    BorderGuruEmail.log(content)
  end

end
