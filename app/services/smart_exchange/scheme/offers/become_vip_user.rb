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
              text = ''
              text += "Fill in email not completed\r\n" unless fill_in_email?
              text += "Invite three friends not completed\r\n" unless invite_three_friends?
              text += "Make first order not completed\r\n" unless make_first_order?
              text += "Please finish all those tasks before to try again.\r\n"
              messenger.text! text unless text.empty?
            end
          else
            messenger.text! I18n.t('bot.exchange.offers.become_vip_user.you_already_completed_this_challenge')
          end
        end

        def fill_in_email?
           RewardManager.new(user, task: :fill_in_email).ended?
        end

        def invite_three_friends?
          RewardManager.new(user, task: :invite_three_friends).ended?
        end

        def make_first_order?
          RewardManager.new(user, task: :make_first_order).ended?
        end

        def reward_manager
          @reward_manager ||= RewardManager.new(user, task: :become_vip_user)
        end
      end
    end
  end
end
