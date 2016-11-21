module Helpers
  module Request

    def request_wirecard_post(params)
      {:postback => JSON.generate(params)}
    end

  end
end
