class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class FillInEmail < Scheme
          extend Options

          valid_until -> { 1.weeks.from_now }

          def request
            '1'
          end

          def response
            if reward_manager.start.success?
              # we try to end the challenge
              # it will go through a validation
              # if it's possible
              if reward_manager.end.success?
                messenger.text! I18n.t('bot.exchange.offers.fill_in_email.email_is_already_valid')
              else
                messenger.text! I18n.t('bot.exchange.offers.fill_in_email.please_enter_your_email')
              end
            else
              messenger.text! I18n.t('bot.exchange.offers.fill_in_email.you_already_completed_this_challenge')
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
