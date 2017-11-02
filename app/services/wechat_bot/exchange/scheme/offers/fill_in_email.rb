class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class FillInEmail < Scheme

          VALID_UNTIL = 1.hours.from_now.freeze

          def request
            '1'
          end

          def response
            if reward_manager.start
              messenger.text! 'Please enter your email'
            else
              messenger.text! 'You already completed this challenge.'
            end
          end

          def reward_manager
            @reward_manager ||= RewardManager.new(user, task: :fill_in_email)
          end
        end
      end
    end
  end
end
