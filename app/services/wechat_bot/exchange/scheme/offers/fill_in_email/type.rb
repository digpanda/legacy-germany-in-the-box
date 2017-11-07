class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class FillInEmail < Scheme
          class Type < Scheme

            VALID_UNTIL = -> { 30.minutes.from_now }

            def request
              ''
            end

            def response
              if user.update(email: email)
                messenger.text! I18n.t('bot.exchange.offers.fill_in_email.type.email_was_updated')
              else
                messenger.text! I18n.t('bot.exchange.offers.fill_in_email.type.email_is_not_valid')
                false
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
end
