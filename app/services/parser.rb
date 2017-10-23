require 'rest-client'
require 'open-uri'

class Parser
  class << self
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
      #
      # TESTS FOR WRITING AND READING A FILE MANUALLY BEFORE TO TRANSFER IT
      media_content = open(file).read
      FileUtils.mkdir_p "#{Rails.root}/public/images/tmp/"
      end_file = File.open("#{Rails.root}/public/images/tmp/some_file", "wb")
      end_file.write(media_content)
      # END OF TESTS

      rest_result = RestClient.post(url, upload: { file: open("#{Rails.root}/public/images/tmp/some_file"), multipart: true })
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
  end
end
