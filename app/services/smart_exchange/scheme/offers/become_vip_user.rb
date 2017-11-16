module SmartExchange
  module Scheme
    class Offers < Base
      class BecomeVipUser < Base

        # valid_until -> { 1.weeks.from_now }

        def request
          '3'
        end

        def response
          if reward_manager.start.success?
            # we try to end the challenge
            # it will go through a validation
            # if it's possible
            if reward_manager.end.success?
              messenger.text! 'Congratulations, you completed all the previous challenges, you are now VIP !')
            else
              messenger.text! "Fill in email not completed" unless fill_in_email?
              messenger.text! "Invite three friends not completed" unless invite_three_friends?
              messenger.text! "Make first order not completed" unless make_first_order?
              messenger.text! "Please finish all those tasks before to try again."
            end
          else
            messenger.text! I18n.t('bot.exchange.offers.become_vip_user.you_already_completed_this_challenge')
          end
        end

        def reward_manager
          @reward_manager ||= RewardManager.new(user, task: :become_vip_user)
        end
      end
    end
  end
end
