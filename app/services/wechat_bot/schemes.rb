# we make sure all is loaded to get the constants and subclasses
Dir["#{File.dirname(__FILE__)}/schemes/**/*.rb"].each {|file| load file}
# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
class WechatBot
  class Schemes < Base
    attr_reader :user, :request

    def initialize(user, request)
      @user = user
      @request = request
    end

    # TODO : don't forget to comment everything here, it's way too complex

    def perform
      # first way (will be refactored to match the other way afterwards)
      if requests[request]

        # now we add entries in the database by splitting the next requests into keys
        binding.pry
        return requests[request].response

      end

      # now we check the databases entries and check the exact same way

      # - "word" => Action::Blabla in database each entry like this
      # - recovering by searching where(key: "") (order by c_at reversed in case of conflict)
      # - manage the "" case which is automatically triggered
      # - one match per research only then quit.
      # - expiration customizable from the subclass itself (for things like "enter your email" shouldn't be more than 5 minutes for instance)
    end

    def subclasses(target)
      SubclassLoader.new(target).perform
    end

    # get all the child request (messages / actions)
    def requests
      @requests ||= begin
        subclasses(self.class).reduce({}) do |acc, subclass|
          acc["#{subclass.new.request}"] = subclass
          acc
        end
      end
    end

    # we insert a breakpoint in the database
    # def insert(breakpoint)
    #   unless breakpoints.include? breakpoint
    #     MemoryBreakpoint.create!(user: user, breakpoint: breakpoint, valid_until: 1.hour.from_now.utc)
    #   end
    # end

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

    def breakpoints
      user.memory_breakpoints.still_valid.map(&:breakpoint) # .map(&:deep_symbolize_keys)
    end

  end
end
