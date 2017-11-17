module SmartExchange
  module Scheme
    class Offers < Base
      class InviteThreeFriends < Base

        # valid_until -> { 1.weeks.from_now }

        def request
          '2'
        end

        def response
          if reward_manager.start.success?
            # we try to end the challenge
            # it will go through a validation
            # if it's possible
            if reward_manager.end.success?
              messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.you_already_completed_this_challenge')
            else
              messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.please_share', balance: balance,total_friends: total_friends, friends_left: friends_left, link_to_share: link_to_share)
            end
          else
            messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.you_already_completed_this_challenge')
          end
        end

        def balance
          15 * user.friends.count
        end

        def total_friends
          user.friends.count
        end

        def friends_left
          3 - user.friends.count
        end

        def link_to_share
          guest_package_sets_url(friend: user.id)
        end

        def reward_manager
          @reward_manager ||= RewardManager.new(user, task: :invite_three_friends)
        end
      end
    end
  end
end
