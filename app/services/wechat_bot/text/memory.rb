# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
class WechatBot
  class Text < Base
    class Memory < Base
      attr_reader :user, :exchange

      def initialize(user, exchange)
        @user = user
        @exchange = exchange
      end

      def perform

        # TODO :
        # - we insert one `exchange`
        # - we check if this `exchange` isn't already on one of our selector in MemoryBreakpoint (no idea why yet)
        # - if it's on a correct selector we alter the memorybreakpoint accordingly
        # - we execute the method in a recursive way

      end

      # we insert a breakpoint in the database
      def insert(breakpoint)
        unless breakpoints.include? breakpoint
          MemoryBreakpoint.create!(user: user, breakpoint: breakpoint, valid_until: 1.hour.from_now.utc)
        end
      end

      # ERB.new().result <-- understand instance variable, very good
      def responses
        file = File.read File.join(File.dirname(__FILE__), "schemes.yml")
        YAML.load(file).deep_symbolize_keys!
      end

      # for each breakpoints defined in memory
      # we will try to process them
      # it returns true and exit the process if there's a matching one
      # if there's nothing matching at the end it returns false
      def process_breakpoints
        breakpoints.each do |breakpoint|
          if defined?(breakpoint)
           if self.send(breakpoint)
             return true
           end
          end
        end
        false
      end

      private

        # the five tasks challenge is a challenge which makes interactions between
        # the customer and wechat bot
        def five_tasks_challenge
          case exchange
          when '1'
            messenger.text 'you just typed 1 after the breakpoint, it works !'
            true
          when '2'
            messenger.text 'yeah boy you did it on 2 this time'
            true
          else
            false
          end
        end

        def breakpoints
          user.memory_breakpoints.still_valid.map(&:breakpoint).map(&:deep_symbolize_keys)
        end

    end
  end
end
