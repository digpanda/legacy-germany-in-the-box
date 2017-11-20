# we manage the memory of the bot and trigger different events depending  on what the customer transmit
# so far it's used only with Wechat Bot but could be astracted elsewhere later on by changing it a little bit.
module SmartExchange
  class Process < Base
    # this is the starting point to
    # load the requests / responses
    # it can be changed to any namespace / class
    BASE_NAMESPACE = Scheme
    # the wildcard used to consider a request as valid
    # it is used for instance when we ask to enter an email
    # and anything the user write after is considered a match
    MATCH_WILDCARD = ''

    def perform
      return true unless matches_base? == false
      return true unless matches_breakpoints? == false
      false
    end

    private

    # if it matches the base schemes we just stop the process there
    # if this method returns false it'll continue to search around
    # the `:continue` is either a specific response from within the scheme
    # or from the unfound processed match
    def matches_base?
      subclasses(BASE_NAMESPACE).each do |subclass|
        response = process_match(subclass)
        # please referrer to #matches_breakpoints?
        # for explanation of those lines
        next if response == :continue
        return true if response == false

        return response
      end
      false
    end

    # same logic than #matches_base?
    # but with memory breakpoints
    def matches_breakpoints?
      breakpoints.fetch.each do |breakpoint|
        # if this class does not exist we remove the breakpoint
        # and next the loop
        unless valid_class?(breakpoint.class_trace)
          breakpoint.delete
          next
        end
        # we can safely instantiate the class here
        response = process_match(breakpoint.class_trace.constantize)
        # we skip this breakpoint if the response is :continue which happens
        # if no match or manually through the called class
        next if response == :continue
        # the logic here is even if the response is false (boolean)
        # we lock the system as if it succeeded
        # to avoid firing other events, while giving the chance
        # to the same sequence to repeat itself on request
        return true if response == :keep

        breakpoint.delete
        return true if response == :destroy

        return response
      end
      false
    end

    # check the class and see if it is a match
    # if it is a match we return the class #response
    # if not we end up with `:continue` which will
    # result searching through other classes
    def process_match(class_match)
      class_instance = instance(class_match)
      class_request = class_instance.request
      # we check if it matches
      if class_request == request || class_request == MATCH_WILDCARD
        # we insert all its subclasses
        final_response = class_instance.response
        insert_subclasses(class_match) unless final_response == :destroy
        return final_response
      end
      :continue
    end

    # we will insert in database all the subclasses of `mainclass`
    # and possible next matching keys
    def insert_subclasses(mainclass)
      subclasses(mainclass).each do |subclass|
        class_instance = instance(subclass)
        request_key = class_instance.request
        breakpoints.insert(request_key, subclass)
      end
    end

    # will load all the subclasses of `origin_class`
    def subclasses(origin_class)
      Utils::SubclassLoader.new(origin_class).perform
    end

    # we can customize the parameters given to each class
    # this line will be used when instanciating the subclasses
    # for request or response
    def instance(to_process)
      to_process.new(user, request)
    end

    def valid_class?(class_name)
      class_name.constantize
      true
    rescue NameError
      false
    end

    def breakpoints
      @breakpoints ||= Breakpoints.new(user, request)
    end
  end
end
