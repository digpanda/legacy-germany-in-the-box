class WeixinApiJsConfig < BaseService
  attr_reader :request, :ticket

  def initialize(request: nil, ticket: nil)
    @request = request
    @ticket = ticket
  end

  def resolve
    return return_with(:error, signature_gateway.error) unless signature_gateway.success?
    return_with(:success, config)
  end

  private

  # TODO : app_id should be centralized and the different APIs as well.
  def config
    {
      app_id: ENV["wechat_username_mobile"],
      timestamp: timestamp,
      nonce_str: nonce_str,
      signature: signature,
      js_api_list: js_api_list
    }
  end

  def timestamp
    @timestamp ||= Time.now.to_i.to_s
  end

  def nonce_str
    @nonce_str ||= SecureRandom.uuid.tr('-', '')
  end

  def signature
    @signature ||= signature_gateway.data[:signature]
  end

  def signature_gateway
     @signature_gateway ||= WeixinApiSignature.new(request: request, ticket: ticket, nonce_str: nonce_str, timestamp: timestamp).resolve
  end

  def js_api_list
    ['onMenuShareTimeline', 'onMenuShareAppMessage']
  end

end
