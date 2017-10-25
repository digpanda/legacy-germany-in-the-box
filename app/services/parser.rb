require 'rest-client'
require 'open-uri'

class Parser
  class << self

    def valid_json?(json)
      JSON.parse(json)
      true
    rescue Exception
      false
    end

    def get(url)
      Net::HTTP.get(URI.parse(url))
    end

    def get_json(url)
      to_hash get(url)
    rescue Exception => exception
      {error: exception}
    end

    def to_hash(string)
      JSON.parse string
    rescue Exception => exception
      {error: exception}
    end

    def post_media(url, file)
      # to_hash RestClient.post(url, upload: { file: File.new(file, 'rb'), multipart: true })
      # http://local.dev:3000/images/logo.png
      # "#{Rails.root}/public/images/no_image_available.jpg"
      # Parser.post_media("local.dev:3000/guest/links", "http://local.dev:3000/images/logo.png")
      # Parser.post_media("local.dev:3000/guest/links", "#{Rails.root}/public/images/no_image_available.jpg")
      rest_result = RestClient.post(url, upload: { file: open(file), multipart: true })
      SlackDispatcher.new.message("REST RESULT #{rest_result}")
      to_hash rest_result
    rescue Exception => exception
      {error: exception}
    end

    # def open_file(file)
    #   # open(file) { |f| f.read }
    # end

    def post_json(url, body)
      header = { 'Content-Type': 'text/json' }
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri, header)
      req.body = body.to_json
      res = https.request(req)
      to_hash res.body
    rescue Exception => exception
      {error: exception}
    end

    def render_template(file:, params:{})
      content = File.read file
      content.gsub(/{{\w+}}/, data_template(params))
    end

    def data_template(params)
      params.each_with_object({}) do |(key,value), hash|
        hash["{{#{key}}}"] = REXML::Text.new(value.to_s)
      end
    end

  end
end
