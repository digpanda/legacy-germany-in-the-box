module WechatBot
  module Exchange
    class Process < Base
      class Breakpoints
        attr_reader :user, :request

        # NOTE : this will be extended to multiple possible adapter for the memory
        def initialize(user, request)
          @user = user
          @request = request
        end

        # we force delete all the whole entries matching the subclass
        # to prevent the same event to fire multiple times
        def insert(request_key, class_trace)
          MemoryBreakpoint.where(user: user, class_trace: class_trace).delete_all
          # class_trace.exec_valid_until
          MemoryBreakpoint.create!(user: user, request_key: request_key, class_trace: class_trace, valid_until: 7.days.from_now)
        end

        # get all the matching requests breakpoints with the request
        # NOTE : right now it's a very simple system but it could be improved via REGEX
        def fetch
          @fetch ||= MemoryBreakpoint.where(user: user).still_valid.any_of({request_key: request}, {request_key: ""}, {request_key: nil}).order_by(c_at: :desc)
        end
      end
    end
  end
end
