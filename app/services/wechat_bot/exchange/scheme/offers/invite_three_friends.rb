class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class InviteThreeFriends < Scheme

          VALID_UNTIL = -> { 1.hours.from_now }

          def request
            '2'
          end

          def response
            if reward_manager.start.success?
              # we try to end the challenge
              # it will go through a validation
              # if it's possible
              if reward_manager.end.success?
                messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.you_already_invited_friends')
              else
                messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.please_share', total_friends: total_friends, link_to_share: link_to_share)
              end
            else
              messenger.text! I18n.t('bot.exchange.offers.invite_three_friends.you_already_completed_this_challenge')
            end
          end

          def total_friends
            user.friends.count
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
end
