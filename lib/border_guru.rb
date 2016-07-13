require 'border_guru/payloads/all'
require 'border_guru/requests/all'
require 'border_guru/responses/all'

# This class should be all you will ever need from the BorderGuru
# interface. To know the methods' return values have a look at their
# respective Response class in the BorderGuru::Response module.
# This class name is always the first parameter in the call to
# #make_request.
module BorderGuru

  class << self

    def calculate_quote(cart:, shop:, country_of_destination:, currency:) 
      make_request(:QuoteApi,
        cart: cart,
        shop: shop,
        country_of_destination: country_of_destination,
        currency: currency
      ) do |response|
        cart.submerchant_id = shop.id
        cart.border_guru_quote_id = response.quote_identifier
        cart.shipping_cost = response.shipping_cost
        cart.tax_and_duty_cost = response.tax_and_duty_cost
      end
    end

    def get_shipping(order:, shop:, country_of_destination:, currency:)
      make_request(:ShippingApi,
        order: order,
        shop: shop,
        country_of_destination: country_of_destination,
        currency: currency
      ) do |response|
        order.border_guru_shipment_id = response.shipment_identifier
        order.border_guru_link_tracking = response.link_tracking
        order.border_guru_link_payment = response.link_payment
      end
    end

    # You can call #bindata on the return value and make the
    # returned bindata the body of a new outgoing HTTP response.
    # This will make the server reply with a PDF download.
    def get_label(border_guru_shipment_id:)
      make_request :LabelApi,
        border_guru_shipment_id: border_guru_shipment_id
    end

    def cancel_order(border_guru_shipment_id:)
      make_request :CancelOrderApi,
        border_guru_shipment_id: border_guru_shipment_id
    end

    # You can call #bindata on the return value and make the
    # returned bindata the body of a new outgoing HTTP response.
    # This will make the server reply with a PDF download.
    def get_label(border_guru_shipment_id:)
      make_request :LabelApi,
        border_guru_shipment_id: border_guru_shipment_id
    end

    def announce_dispatch(order:, dispatcher:)
      make_request :TrackingApi,
        order: order,
        dispatcher: dispatcher
    end

    private

    def make_request(api_name, *payload_args)
      payload = Payloads.const_get(api_name).new *payload_args
      request = Requests.const_get(api_name).new payload
      request.dispatch!
      Responses.const_get(api_name).new(request).tap do |response|
        yield response if block_given?
      end
    end

  end

end

