require 'border_guru_ftp/transfer_orders'

module BorderGuruFtp

  Error = Class.new(StandardError)
  
  class << self

    def transfer_orders(orders)
      TransferOrders.new(orders).generate_and_store_local
    end

  end

end