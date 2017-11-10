module WechatBot
  module Exchange
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

        # NOTE : it works if i do it this way.
        # TODO : try to find a way to abstract it and use it from anywhere.
        # FROM A METHOD FOR INSTANCE
        trigger_response = Proc.new do |target_class, breakpoint|
          response = process_match(target_class)
          # we skip this breakpoint if the response is :continue which happens
          # if no match or manually through the called class
          next if response == :continue
          # the logic here is even if the response is false (boolean)
          # we lock the system as if it succeeded
          # to avoid firing other events, while giving the chance
          # to the same sequence to repeat itself on request
          return true if response == false

          breakpoint.delete if breakpoint
          return response
        end

        subclasses(BASE_NAMESPACE).each do |subclass|
          trigger_response.call(
            subclass
          )
        end
        false
      end

      # same logic than #matches_base?
      # but with memory breakpoints
      def matches_breakpoints?
        breakpoints.fetch.each do |breakpoint|
          trigger_response.call(
            breakpoint.class_trace.constantize,
            breakpoint
          )
        end
        false
      end

      # def trigger_response
      #   return Proc.new do |target_class, breakpoint|
      #     response = process_match(target_class)
      #     # we skip this breakpoint if the response is :continue which happens
      #     # if no match or manually through the called class
      #     next if response == :continue
      #     # the logic here is even if the response is false (boolean)
      #     # we lock the system as if it succeeded
      #     # to avoid firing other events, while giving the chance
      #     # to the same sequence to repeat itself on request
      #     return true if response == false
      #
      #     breakpoint.delete if breakpoint
      #     return response
      #   end
      # end

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
          insert_subclasses(class_match)
          return class_instance.response
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

      def breakpoints
        @breakpoints ||= Breakpoints.new(user, request)
      end
    end
  end
end
