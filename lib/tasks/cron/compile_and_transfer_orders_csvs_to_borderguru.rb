require 'border_guru_ftp'

class Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the current orders ..."
    @orders = Order.where(status: :custom_checkable).where(logistic_partner: :borderguru).all
  end

  def perform

    if Setting.instance.logistic_partner == :borderguru

      unless orders.length.zero?
        begin
          BorderGuruFtp.transfer_orders(orders)
        rescue BorderGuruFtp::Error => exception
          devlog "A problem occured while preparing the orders (#{exception.message})."
          return
        end
      end

    else
      devlog "Logistic partner is not BorderGuru, we skip the processing."
    end

    devlog "Process finished."

  end

  def devlog(content)
    BorderGuruFtp.log(content)
  end

end
