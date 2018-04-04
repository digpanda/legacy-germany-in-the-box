require 'uri'

# service to solve anything related to URLs
# such as adding a get parameter to an existing URL
class UrlSolver < BaseService
  attr_reader :url, :app_type

  def initialize(url, app_type: :rails)
    @url = url
    @app_type = app_type
  end

  def insert_get(hash)
    key = hash.keys.first
    value = hash.values.first

    # will add classically the gets to the URL
    if app_type == :rails
      uri_array = URI.decode_www_form(String(uri.query)) << [key, value]
      uri.query = URI.encode_www_form(uri_array)
      uri.to_s

    # vuejs is a little special as it understands the gets parameters upside down
    # we have to place it after the /#/ manually
    elsif app_type == :vuejs
      uri_array = URI.decode_www_form(String(uri.query)) << [key, value]
      uri_with_gets = URI.encode_www_form(uri_array)
      "#{url}\#/?#{uri_with_gets}"
    end
  end

  def uri
    @uri ||= URI.parse(url)
  end

end
