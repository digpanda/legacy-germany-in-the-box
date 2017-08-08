module Helpers
  module Service
    module_function

    def service_success(details = nil)
      BaseService.new.return_with(:success, details)
    end

    def service_error(details = nil)
      BaseService.new.return_with(:error, details)
    end
  end
end
