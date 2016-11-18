module Helpers
  module Response

    module_function

    def response_json_body
      JSON.parse(response.body)
    end

  end
end
