class WeixinApiSignature < BaseService
  attr_reader :request, :ticket, :nonce_str, :timestamp

  def initialize(request: nil, ticket: nil, nonce_str: nil, timestamp: nil)
    @request = request
    @ticket = ticket
    @nonce_str = nonce_str
    @timestamp = timestamp
  end

  def resolve
    return_with(:success, signature: signature)
  end

  private

    def signature
      Digest::SHA1.hexdigest(raw)
    end

    def raw
      "jsapi_ticket=#{ticket}&noncestr=#{nonce_str}&timestamp=#{timestamp}&url=#{request.original_url}"
    end
end
