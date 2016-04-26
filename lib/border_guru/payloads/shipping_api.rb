require 'border_guru/payloads/concerns/having_vendibles'

module BorderGuru
  module Payloads
    class ShippingApi
      include HavingVendibles

      def initialize(order:, shop:, country_of_destination:, currency:)
        @order = order
        @shop = shop
        @country_of_destination = country_of_destination
        @currency = currency
      end

      def to_h
        product_summaries(@order).merge({
          totalPrice: @order.total_value,
          countryOfOrigin: @shop.country_of_dispatcher.alpha2,
          countryOfDestination: @country_of_destination.alpha2,
          currency: @currency,
          quoteIdentifier: @order.border_guru_quote_id,
          merchantOrderId: @order.order_number,
          storeName: @shop.name,
          dimensionalWeight: @order.total_weight,
          dimensionalWeightScale: WEIGHT_UNIT,
          lineItems: line_items,
          shippingAddress: [address(@order.shipping_address)],
          billingAddress: [address(@order.billing_address)],
        })
      end

      private

      def address(address_model)
        {
          firstName: address_model.first_name,
          lastName: address_model.last_name,
          streetName: address_model.street_and_house_no,
          additionalInfo: address_model.addition,
          postcode: address_model.post_code,
          city: address_model.city,
          country: address_model.country_name,
          telephone: address_model.telephone,
          email: address_model.email,
          countryCode: address_model.country_code
        }
      end

      def line_items
        super @order.order_line_items.each do |prod|
          {
            quantity: prod.quantity_ordered
          }
        end
      end
    end
  end
end
