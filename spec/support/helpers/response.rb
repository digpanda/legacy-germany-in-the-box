module Helpers
  module Response

    def response_json_body
      JSON.parse(response.body)
    end

  end
end
