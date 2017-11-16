module SmartExchange
  module Scheme
    class Console < Base
      class ClearRewards < Base

        # valid_until -> { 7.days.from_now }

        def request
          'clear rewards'
        end

        def response
          user.rewards.delete_all
          messenger.text! 'Your rewards were erased.'
        end
      end
    end
  end
end
