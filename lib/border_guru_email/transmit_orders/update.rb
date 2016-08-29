module BorderGuruEmail
  class TransmitOrders
    class Update < Base

      # update the order model accordingly
      def confirm_sent!
        orders.each do |order|
          binding.pry
          order.hermes_pickup_email_sent_at = Time.now
          order.save
        end
      end

    end
  end
end
