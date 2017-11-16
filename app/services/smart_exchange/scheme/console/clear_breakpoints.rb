module SmartExchange
  module Scheme
    class Console < Base
      class ClearBreakpoints < Base

        # valid_until -> { 7.days.from_now }

        def request
          'clear breakpoints'
        end

        def response
          MemoryBreakpoint.delete_all
          messenger.text! 'All breakpoints were erased.'
        end
      end
    end
  end
end
