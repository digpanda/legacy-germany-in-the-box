module WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Console < Scheme
        class ResetRewards < Scheme
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
