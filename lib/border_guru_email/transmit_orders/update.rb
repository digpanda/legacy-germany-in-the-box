module BorderGuruEmail
  class TransmitOrders
    class Update < Base

      def confirm_sent!
        orders.each do |order|
          order.hermes_pickup_email_sent_at = Time.now
          order.save
        end
      end
      
    end
  end
end
