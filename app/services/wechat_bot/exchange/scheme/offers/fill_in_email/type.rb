class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Offers < Scheme
        class FillInEmail < Scheme
          class Type < Scheme

            VALID_UNTIL = 30.minutes.from_now.freeze

            def request
              ''
            end

            def response
              if user.update(email: email)
                messenger.text! 'Thank you very much. Your profile is now up to date. Please check your inbox and confirm your email to receive your reward.'
              else
                messenger.text! "This email is not valid."
                # will allow the system to repeat it
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

            # we end the reward and read it to the customer
            def read_reward
              reward_manager.end
              messenger.text! "#{reward_manager.read}"
            end

          end
        end
      end
    end
  end
end
