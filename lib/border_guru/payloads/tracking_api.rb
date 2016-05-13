require 'border_guru/payloads/concerns/having_vendibles'

module BorderGuru
  module Payloads
    class TrackingApi

      def initialize(order:, dispatcher:)
        @order = order
        @dispatcher = dispatcher
      end

      def to_h
        {
          merchantOrderId: @order.id.to_s,
          trackingStatus: 'EN_ROUTE',
          trackingLocation: location,
          trackingMessage: 'Parcel left warehouse',
          trackingTimestamp: Time.now.to_i * 1000,
          trackingWeight: @order.total_weight,
          trackingWeightScale: BorderGuru::Payloads::HavingVendibles::WEIGHT_UNIT
        }
      end

      private

      def location
        "#{@dispatcher.city}, #{@dispatcher.country.name}"
      end

    end
  end
end
