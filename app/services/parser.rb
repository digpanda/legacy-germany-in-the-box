class Parser
  class << self
    def get(url)
      Net::HTTP.get(URI.parse(url))
    end

    def get_json(url)
      JSON.parse get(url)
    rescue Exception => exception
      {}
    end

    def post_json(url, body)
      header = { 'Content-Type': 'text/json' }
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri, header)
      req.body = body.to_json
      res = https.request(req)
      JSON.parse(res.body)
    rescue Exception => exception
      {}
    end
  end
end
