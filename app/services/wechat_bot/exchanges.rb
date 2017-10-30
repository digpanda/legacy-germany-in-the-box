# we make sure all is loaded to get the constants and subclasses
Dir["#{File.dirname(__FILE__)}/Exchanges/**/*.rb"].each {|file| load file}
# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
class WechatBot
  class Exchanges < Base
    attr_reader :user, :request

    def initialize(user, request)
      @user = user
      @request = request
    end

    def stored_breakpoints
      @stored_breakpoints || MemoryBreakpoint.where(user: user).still_valid.any_of({request_key: request}, {request_key: ""}).order_by(c_at: :desc)
    end

    # TODO : don't forget to comment everything here, it's way too complex

    def perform

      # we check from the `Exchanges` class and analyze all its subclasses
      return unless process_request(self.class) == false

      # we will do the same from memory breakpoint now
      stored_breakpoints.each do |memory_breakpoint|
        response = process_request(memory_breakpoint.class_trace.constantize)
        if response != false
          memory_breakpoint.delete
          return response
        end
      end
    end

    # take a class and try to solve the request with all its subclasses
    # if one subclass matches we run it completely and return its #response
    # if the #response is stricly a false boolean we continue to roll
    def process_request(mainclass)
      # we check all the start point Exchanges (at the top of `/Exchanges/`)
      requests = fetch_subclasses(mainclass)
      # if any request matches with one entry point we process it
      if requests[request]
        # we basically insert the subclasses of this matching scheme if they exist
        # and we process the #response
        insert_subclasses(requests[request])
        # TODO : add a system to insert user / request
        return requests[request].new.response
      end
      false
    end

    # we will insert in database all the subclasses of `mainclass`
    # and possible next matching keys
    def insert_subclasses(mainclass)
      fetch_subclasses(mainclass).each do |subrequest|
        request_key = subrequest.first
        class_trace = mainclass # subrequest.last
        MemoryBreakpoint.first_or_create!(user: user, request_key: request_key, class_trace: class_trace, valid_until: 1.days.from_now)
      end
    end

    # will load all the subclasses of `origin_class`
    def subclasses(origin_class)
      SubclassLoader.new(origin_class).perform
    end

    # get all the child request (messages / actions)
    def fetch_subclasses(origin_class)
      subclasses(origin_class).reduce({}) do |acc, subclass|
        acc["#{subclass.new.request}"] = subclass
        acc
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
