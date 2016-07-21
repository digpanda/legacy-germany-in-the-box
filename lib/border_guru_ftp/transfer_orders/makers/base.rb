module BorderGuruFtp
  class TransferOrders
    module Makers
      class Base

        attr_reader :orders, :shop

        def initialize(orders, *args)
          @orders = orders
          @shop = orders.first.shop # the orders there should all be from one specific shop to avoid conflicts
        end

        def border_guru_merchant_id
          @border_guru_merchant_id ||= shop.bg_merchant_id || "1026-TEST-#{Random.rand(1000)}"
        end

      end
    end
  end
end