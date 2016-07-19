module BorderGuruFtp
  module Makers
    class Base

      CONFIG = Rails.application.config.border_guru

      attr_reader :orders, :shop

      def initialize(orders, *args)
        @orders = orders
        @shop = orders.first.shop
      end

      def border_guru_merchant_id
        @border_guru_merchant_id ||= shop.bg_merchant_id || "1026-TEST-#{Random.rand(1000)}"
      end

    end
  end
end