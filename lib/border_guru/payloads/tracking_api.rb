require_relative 'concerns/having_vendibles'

module BorderGuru
  module Payloads
    class TrackingApi

      def initialize(order:, dispatcher:)
        I18n.locale = :'zh-CN'
        @order = order
        @dispatcher = dispatcher
      end

      def to_h
        {
          merchantOrderId: @order.border_guru_order_id,
          trackingStatus: 'EN_ROUTE',
          trackingLocation: location,
          trackingMessage: 'Parcel left warehouse',
          trackingTimestamp: Time.now.utc.to_i * 1000,
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
