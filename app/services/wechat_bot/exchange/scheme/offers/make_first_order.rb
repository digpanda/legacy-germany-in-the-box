module WechatBot
  module Exchange
    module Scheme
      class Offers < Base
        class MakeFirstOrder < Base
          extend Options

          valid_until -> { 1.weeks.from_now }

          def request
            '3'
          end

          def response
            if reward_manager.start.success?
              # we try to end the challenge
              # it will go through a validation
              # if it's possible
              if reward_manager.end.success?
                messenger.text! I18n.t('bot.exchange.offers.make_first_order.you_already_made_an_order')
              else
                messenger.text! I18n.t('bot.exchange.offers.make_first_order.please_make_order')
              end
            else
              messenger.text! I18n.t('bot.exchange.offers.make_first_order.you_already_completed_this_challenge')
            end
          end

          def reward_manager
            @reward_manager ||= RewardManager.new(user, task: :make_first_order)
          end
        end
      end
    end
  end
end
