module BorderGuruEmail
  class TransmitOrders

    MINIMUM_EMAIL_SENDING_DATE = 80.hours.from_now

    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def send_emails
      orders_by_shop.each do |shop_orders|
        Dispatch.new(sendable_orders(shop_orders)).to_email
      end
    end

    def update_orders!
      #Update.new(sendable_orders(orders)).confirm_sent!
    end

    private

    def sendable_orders(orders)
      orders.select { |order| email_sendable?(order) && order.order_items.any? }
    end

    def email_sendable?(order)
      (order.minimum_sending_date < MINIMUM_EMAIL_SENDING_DATE) && !order.hermes_pickup_email_sent_at
    end

    def orders_by_shop
      @orders_by_shop ||= orders.group_by(&:shop_id).values
    end

  end
end