module BorderGuruEmail
  class TransmitOrders
    class Base

      attr_reader :orders, :shop, :shopkeeper

      def initialize(orders, *args)
        @orders = orders
        @shop = orders.first.shop
        @shopkeeper = shop.shopkeeper
      end

    end
  end
end