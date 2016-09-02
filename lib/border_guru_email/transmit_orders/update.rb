module BorderGuruEmail
  class TransmitOrders
    class Update < Base

      # update the order model accordingly
      def confirm_sent!
        orders.each do |order|
          order.hermes_pickup_email_sent_at = Time.now.utc
          order.save
        end
      end

    end
  end
end
