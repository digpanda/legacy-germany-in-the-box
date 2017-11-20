module SmartExchange
  module Scheme
    class Console < Base
      class ResetEmail < Base

        # we will reset the email to a fake wechat one
        def request
          'clear breakpoints'
        end

        def response
          user.email = "#{user.wechat_unionid}@wechat.com"
          user.skip_confirmation!
          user.save(validate: false)
          user.reload
          messenger.text! "Your unvalid email is now : #{user.email}"
        end
      end
    end
  end
end
