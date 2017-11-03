class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class InviteThreeFriends < Scheme

          VALID_UNTIL = 1.hours.from_now.freeze

          def request
            '2'
          end

          def response
            reward_manager.reward.delete
            messenger.text! 'delete'
            return
            if reward_manager.start
              # we try to end the challenge
              # it will go through a validation
              # if it's possible
              if reward_manager.end
                messenger.text! 'You already invited 3 friends. Congratulation !'
              else
                messenger.text! "You got #{total_friends} friends. Please share this link with your friends : #{link_to_share}"
              end
            else
              messenger.text! 'You already completed this challenge.'
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
