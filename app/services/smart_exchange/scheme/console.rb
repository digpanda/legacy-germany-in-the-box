module SmartExchange
  module Scheme
    class Console < Base

      # valid_until -> { 7.days.from_now }

      def request
        'console'
      end

      def response
        messenger.text! "Console activated for #{user.full_name}"
      end
    end
  end
end
