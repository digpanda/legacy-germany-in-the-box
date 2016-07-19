require 'border_guru_ftp/order_transfers/makers/all'

module BorderGuruFtp
  class OrderTransfers

    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def generate_and_store_local
      Makers::Store.new(orders, orders_csv).to_local
    end

    private

    def orders_csv
      Makers::Generate.new(orders).to_csv
    end

  end
end