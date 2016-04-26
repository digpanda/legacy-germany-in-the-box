require 'border_guru/payloads/concerns/having_vendibles'

module BorderGuru
  module Payloads
    class QuoteApi
      include HavingVendibles

      def initialize(cart:, shop:, country_of_destination:, currency:)
        @cart = cart
        @shop = shop
        @country_of_destination = country_of_destination
        @currency = currency
      end

      def to_h
        product_summaries(@cart).merge({
          countryOfOrigin: @shop.country_of_dispatcher.alpha2,
          countryOfDestination: @country_of_destination.alpha2,
          currency: @currency,
          lineItems: line_items
        })
      end

      private

      def line_items
        super(@cart.cart_products) do |prod|
          {
            quantity: prod.quantity_in_cart,
          }
        end
      end
    end
  end
end
