require_relative 'concerns/having_vendibles'

module BorderGuru
  module Payloads
    class QuoteApi
      include HavingVendibles

      def initialize(order:, shop:, country_of_destination:, currency:)
        I18n.locale = :'zh-CN'
        @order = order
        @shop = shop
        @country_of_destination = country_of_destination
        @currency = currency
      end

      def to_h
        product_summaries(@order).merge({
          countryOfOrigin: @shop.country_of_dispatcher.alpha2,
          countryOfDestination: @country_of_destination.alpha2,
          currency: @currency,
          lineItems: line_items,
          shippingCost: ShippingPrice.new(@order).price
        })
      end

      private

      def line_items
        super(@order.order_items) do |order_item|
          {
            quantity: order_item.quantity,
          }
        end
      end
    end
  end
end
