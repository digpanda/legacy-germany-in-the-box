require 'border_guru_ftp/transfer_orders'

module BorderGuruFtp

  Error = Class.new(StandardError)
  
  class << self

    def prepare_orders(orders)
      TransferOrders.new(orders).generate_and_store_local
    end

    def transfer_orders
      # to do
    end

  end

end