# we make sure all is loaded to get the constants and subclasses
Dir["#{File.dirname(__FILE__)}/exchange/**/*.rb"].each {|file| load file}
# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
class WechatBot
  class Exchange < WechatBot::Base
    attr_reader :user, :request

    # this is the starting point to
    # load the requests / responses
    BASE_CLASS = Scheme

    def initialize(user, request)
      @user = user
      @request = request
    end

    def perform
      # we check from the `Exchange` class and analyze all its subclasses
      return true unless process_request(BASE_CLASS) == false
      # we will do the same from memory breakpoint now
      stored_breakpoints.each do |memory_breakpoint|
        response = process_request(memory_breakpoint.class_trace.constantize)
        if response != false
          memory_breakpoint.delete
          return response
        end
      end
      false
    end

    private

    # take a class and try to solve the request with all its subclasses
    # if one subclass matches we run it completely and return its #response
    # if the #response is stricly a false boolean we continue to roll
    def process_request(mainclass)
      # we check all the start point Exchange (at the top of `/Exchange/`)
      requests = fetch_subclasses(mainclass)
      matching_request = requests[request] || requests['']
      # if any request matches with one entry point we process it
      if matching_request
        # we basically insert the subclasses of this matching scheme if they exist
        # and we process the #response
        insert_subclasses(matching_request)
        return instance(matching_request).response
      end
      false
    end

    # we will insert in database all the subclasses of `mainclass`
    # and possible next matching keys
    def insert_subclasses(mainclass)
      fetch_subclasses(mainclass).each do |subrequest|
        target_subclass = subrequest.last
        request_key = subrequest.first
        class_trace = mainclass
        insert_breakpoint(request_key, class_trace, target_subclass)
      end
    end

    # will load all the subclasses of `origin_class`
    def subclasses(origin_class)
      SubclassLoader.new(origin_class).perform
    end

    # get all the child request (messages / actions)
    def fetch_subclasses(origin_class)
      subclasses(origin_class).reduce({}) do |acc, subclass|
        # we never catch #request within a subclass if it returns false directly
        unless instance(subclass).request == false
          acc["#{instance(subclass).request}"] = subclass
        end
        acc
      end
    end

    # we can customize the parameters given to each classes
    # this line will be used when instanciating the subclasses
    # for request or response
    def instance(to_process)
      to_process.new(user, request)
    end

    # we force delete all the whole entries matching the subclass
    # to prevent the same event to fire multiple times
    def insert_breakpoint(request_key, class_trace, target_subclass)
      # target_subclass get the validity
      MemoryBreakpoint.where(user: user, class_trace: class_trace).delete_all
      MemoryBreakpoint.create!(user: user, request_key: request_key, class_trace: class_trace, valid_until: target_subclass::VALID_UNTIL)
    end

    # get all the matching requests breakpoints with the request
    # NOTE : right now it's a very simple system but it could be improved via REGEX
    def stored_breakpoints
      @stored_breakpoints ||= MemoryBreakpoint.where(user: user).still_valid.any_of({request_key: request}, {request_key: ""}, {request_key: nil}).order_by(c_at: :desc)
    end

  end
end
