module BorderGuruFtp
  class TransferOrders

    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def generate_and_store_local
      orders_by_shop.each do |shop_orders|
        Makers::Store.new(shop_orders, orders_csv(shop_orders)).to_local
      end
    end

    private

    def orders_csv(orders)
      Makers::Generate.new(orders).to_csv
    end

    def orders_by_shop
      orders.group_by(&:shop_id).values
    end

  end
end