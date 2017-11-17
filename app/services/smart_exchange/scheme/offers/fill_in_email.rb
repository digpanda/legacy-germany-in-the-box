module SmartExchange
  module Scheme
    class Offers < Base
      class FillInEmail < Base

        # valid_until -> { 1.weeks.from_now }

        def request
          '1'
        end

        def response
          if reward_manager.start.success?
            # we try to end the challenge
            # it will go through a validation
            # if it's possible
            unless reward_manager.end.success?
            #   messenger.text! I18n.t('bot.exchange.offers.fill_in_email.you_already_completed_this_challenge')
            # else
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
