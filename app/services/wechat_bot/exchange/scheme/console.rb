module WechatBot
  module Exchange
    module Scheme
      class Console < Base
        extend Options

        def request
          'console'
        end

        def response
          messenger.text! "Console activated for #{user.full_name}"
        end
      end
    end
  end
end
