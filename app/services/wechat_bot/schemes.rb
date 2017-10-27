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
      if requests[request]
        requests[request].response
      end
      # if requests.map(&:keys).include? request
      #   # it's a match
      # end
    end

    def subclasses(target)
      target.constants.map(&target.method(:const_get)).grep(Class).select { |c| c.to_s.include? "::#{target.to_s.split('::').last}" } #c.to_s =~ /^(.*::Schemes::[^::]+)$/ }
    end

    # git all the child request (messages / actions)
    def requests
      @requests ||=
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
