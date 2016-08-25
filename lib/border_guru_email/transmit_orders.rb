module BorderGuruEmail
  class TransmitOrders

    MINIMUM_EMAIL_SENDING_DATE = 27.hours.from_now

    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def send_emails
      sendable_shop_orders.each do |shop_orders|
        Dispatch.new(shop_orders).to_email if shop_orders.any?
      end
    end

    def update_orders!
      sendable_shop_orders.each do |shop_orders|
        Update.new(shop_orders).confirm_sent! if shop_orders.any?
      end
    end

    private

    def sendable_shop_orders
      orders_by_shop.map do |shop_orders|
        shop_orders.select { |order| email_sendable?(order) && order.order_items.any? }
      end
    end

    def email_sendable?(order)
      (order.minimum_sending_date && order.minimum_sending_date < MINIMUM_EMAIL_SENDING_DATE) && !order.hermes_pickup_email_sent_at
    end

    def orders_by_shop
      @orders_by_shop ||= orders.group_by(&:shop_id).values
    end

  end
end
