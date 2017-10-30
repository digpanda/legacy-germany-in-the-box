class WechatBot
  class Exchange < WechatBot::Base
    class Offers < Exchange::Base
      class FillInEmail < Exchange::Base
        class Type < Exchange::Base
          def request
            ''
          end

          def response
            # TODO : make the actual reward process system on top of that.
            if user.update(email: @request)
              messenger.text! 'Thank you very much. Your profile is now up to date.'
            else
              messenger.text! "The format is invalid (#{user.errors.join(', ')})"
            end
          end
        end
      end
    end
  end
end
