module WechatBot
  module Exchange
    class Process < Base
      # this is the starting point to
      # load the requests / responses
      # it can be changed to any namespace / class
      BASE_NAMESPACE = Scheme

      def perform

        subclasses(BASE_NAMESPACE).each do |subclass|
          return true unless process_match(subclass) == false
        end

        # we will do the same from memory breakpoint now
        breakpoints.fetch.each do |breakpoint|
          response = process_match(breakpoint.class_trace.constantize)
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
      def process_match(class_match)
        class_instance = instance(class_match)
        class_request = class_instance.request

        # we check if it matches
        if class_request == request
          # we insert all its subclasses
          insert_subclasses(class_match)
          return class_instance.response
        end
        false
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
