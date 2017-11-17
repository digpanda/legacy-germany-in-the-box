module SmartExchange
  module Scheme
    class Offers < Base
      class BecomeVipUser < Base

        # valid_until -> { 1.weeks.from_now }

        def request
          '4'
        end

        def response
          if reward_manager.start.success?
            # we try to end the challenge
            # it will go through a validation
            # if it's possible
            if reward_manager.end.success?
              messenger.text! I18n.t('bot.exchange.offers.become_vip_user.you_are_vip')
            else
              text = "#{I18n.t('bot.exchange.offers.become_vip_user.please_complete_tasks')}\r\n"
              text += "#{I18n.t('bot.exchange.offers.become_vip_user.please_fill_in_email')}\r\n" unless fill_in_email?
              text += "#{I18n.t('bot.exchange.offers.become_vip_user.please_invite_friends')}\r\n" unless invite_three_friends?
              # text += "#{I18n.t('bot.exchange.offers.become_vip_user.please_make_first_order')}\r\n" unless make_first_order?
              text += "#{I18n.t('bot.exchange.offers.become_vip_user.please_make_three_orders')}\r\n" unless make_three_orders?
              messenger.text! text unless text.empty?
              return :keep
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

        # def make_first_order?
        #   RewardManager.new(user, task: :make_first_order).ended?
        # end

        def make_three_orders?
          user.orders.bought.count >= 3
        end

        def reward_manager
          @reward_manager ||= RewardManager.new(user, task: :become_vip_user)
        end
      end
    end
  end
end
