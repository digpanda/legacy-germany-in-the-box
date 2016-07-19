module BorderGuruFtp
  class TransferOrders

    attr_reader :orders

    def initialize(orders)
      @orders = orders
      # we could add a protection regarding the necessary format for the orders attributes here ? maybe.
    end

    def generate_and_store_local
      Makers::Store.new(orders, orders_csv).to_local
    end

    private

    def orders_csv
      @orders_csv ||= Makers::Generate.new(orders).to_csv
    end

  end
end