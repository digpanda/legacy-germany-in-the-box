class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      module Options

        def valid_until(block)
          @@valid_until = block
        end

        def exec_valid_until
          @@valid_until.call
        end

        def after_match(action)
          @@after_match = action
        end

        def exec_after_match
          @@after_match
        end
      end

    end
  end
end
