require 'border_guru_ftp/order_transfers'

module BorderGuruFtp

  Error = Class.new(StandardError)
  
  class << self

    def transfer_orders(orders)
      OrderTransfers.new(orders).generate_and_store_local
    end

  end

end