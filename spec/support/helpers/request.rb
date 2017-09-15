module Helpers
  module Request
    module_function

    def fake_request
      double('request', original_url: 'http://test.com', session: {}, params: {}, env: { 'warden': nil }, remote_ip: '0.0.0.0')
    end
  end
end
