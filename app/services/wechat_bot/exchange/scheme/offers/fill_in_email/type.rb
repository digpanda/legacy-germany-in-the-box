class WechatBot
  class Exchange < WechatBot::Base
    class Offers < Scheme
      class FillInEmail < Scheme
        class Type < Scheme
          def request
            ''
          end

          def response
            SlackDispatcher.new.message("PROCESSING THE EMAIL NOW")
            # TODO : make the actual reward process system on top of that.
            if user.update(email: email)
              messenger.text! 'Thank you very much. Your profile is now up to date.'
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
        end
      end
    end
  end
end
