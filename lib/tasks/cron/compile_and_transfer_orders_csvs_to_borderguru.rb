require 'border_guru_ftp'

class Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru

  def initialize

    devlog "Let's start to fetch all the current orders ..."

    orders = Order.where(status: :custom_checking).all

    unless orders.length.zero?

      begin
        BorderGuruFtp.transfer_orders(orders)
      rescue BorderGuruFtp::Error => exception
        devlog "A problem occured while preparing the orders (#{exception.message})."
        return
      end

    end

    devlog "Process finished."

  end

  def devlog(content)
    BorderGuruFtp.log(content)
  end

end