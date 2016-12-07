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

    COUNTRY_OF_DESTINATION = ISO3166::Country.new('CN')
    CURRENCY = 'EUR'

    def calculate_quote(order:)
      make_request(:QuoteApi,
        order: order,
        shop: order.shop,
        country_of_destination: COUNTRY_OF_DESTINATION,
        currency: CURRENCY
      ) do |response|
        order.border_guru_quote_id = response.quote_identifier
        order.shipping_cost = ShippingPrice.new(order).price # could be inside the model #response.shipping_cost <-- replace by our own system because borderguru is unable to give it to us
        order.tax_and_duty_cost = response.tax_and_duty_cost
        order.save
      end
    end

    def get_shipping(order:)
      make_request(:ShippingApi,
        order: order,
        shop: order.shop,
        country_of_destination: COUNTRY_OF_DESTINATION,
        currency: CURRENCY
      ) do |response|
        # could be refactored way better but we got no time for that
        # the error managing system is very bad in this library and should be taken care of
        if response.response_data[:success] == false || response.response_data[:error]
          raise BorderGuru::Error, output_error(response)
        end
        order.border_guru_shipment_id = response.shipment_identifier
        order.border_guru_link_tracking = response.link_tracking
        order.border_guru_link_payment = response.link_payment
        order.save
      end
    end

    def cancel_order(border_guru_shipment_id:)
      make_request(:CancelOrderApi,
        border_guru_shipment_id: border_guru_shipment_id
      )
    end

    # You can call #bindata on the return value and make the
    # returned bindata the body of a new outgoing HTTP response.
    # This will make the server reply with a PDF download.
    def get_label(border_guru_shipment_id:)
      make_request(:LabelApi,
        border_guru_shipment_id: border_guru_shipment_id
      )
    end

    def announce_dispatch(order:, dispatcher:)
      make_request(:TrackingApi,
        order: order,
        dispatcher: dispatcher
      )
    end

    private

    def make_request(api_name, *payload_args)
      payload = Payloads.const_get(api_name).new(*payload_args)
      request = Requests.const_get(api_name).new(payload)
      request.dispatch!
      Responses.const_get(api_name).new(request).tap do |response|
        yield response if block_given?
      end
    end

    def output_error(response)
      response.response_data&.[](:error)&.[](:detail)&.[](:error)&.[](:response)&.[](:error)&.[](:message) || response.response_data&.[](:error)&.[](:msg) || response.response_data&.[](:error)
    end

  end
end
