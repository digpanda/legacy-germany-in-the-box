module Helpers
  module Response
    module_function

    def response_json_body
      JSON.parse(response.body)
    end

    def expect_json(hash)
      hash.each do |key, value|
        expect(response_json_body["#{key}"]).to eq(value)
      end
    end
  end
end
