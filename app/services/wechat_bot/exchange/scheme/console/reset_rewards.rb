module WechatBot
  module Exchange
    module Scheme
      class Console < Base
        class ResetRewards < Base
          def request
            'reset rewards'
          end

          def response
            user.rewards.delete_all
            messenger.text! 'Your rewards were erased.'
          end
        end
      end
    end
  end
end
