module SmartExchange
  module Scheme
    class Offers < Base
      class FillInEmail < Base
        class Type < Base

          # valid_until -> { 1.weeks.from_now }

          def request
            ''
          end

          def response
            if user.update(email: email)
              messenger.text! I18n.t('bot.exchange.offers.fill_in_email.type.email_was_updated')
              :destroy
            else
              messenger.text! I18n.t('bot.exchange.offers.fill_in_email.type.email_is_not_valid', error: user.errors.full_messages.join(', '))
              :keep
            end
          end

          private

          def email
            # it's just what the guy typed
            @request
          end

          def reward_manager
            @reward_manager ||= RewardManager.new(user, task: :fill_in_email)
          end
        end
      end
    end
  end
end
