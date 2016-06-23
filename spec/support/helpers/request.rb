module Helpers
  module Request

    module_function

    def request_wirecard_post(params)
      {:postback => JSON.generate(params)}
    end
    
  end
end