module SmartExchange
  module Scheme
    class Console < Base

      # valid_until -> { 7.days.from_now }

      def request
        'quit'
      end

      def response
        breakpoints.clear_all
        messenger.text! "You quit the console"
      end
    end
  end
end
