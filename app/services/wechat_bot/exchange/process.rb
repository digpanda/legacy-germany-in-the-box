module WechatBot
  module Exchange
    class Process < Base
      # this is the starting point to
      # load the requests / responses
      # it can be changed to any namespace / class
      BASE_NAMESPACE = Scheme

      def perform
        # we check from the `Scheme` class and analyze all its subclasses
        return true unless process_request(BASE_NAMESPACE) == false

        # we will do the same from memory breakpoint now
        breakpoints.fetch.each do |breakpoint|
          response = process_request(breakpoint.class_trace.constantize)
          if response == false
            # the logic here is even if the response is false (boolean)
            # we lock the system as if it succeeded
            # to avoid firing other events, while giving the chance
            # to the same sequence to repeat itself on request
            return true
          else
            breakpoint.delete
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
          request_key = subrequest.first
          subclass_trace = subrequest.last
          class_trace = mainclass
          breakpoints.insert(request_key, class_trace, subclass_trace)
        end
      end

      # will load all the subclasses of `origin_class`
      def subclasses(origin_class)
        Utils::SubclassLoader.new(origin_class).perform
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
