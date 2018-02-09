class WechatApi::Ticket < BaseService
  attr_reader :type

  def initialize(type: 'jsapi')
    @type = type
  end

  def resolve
    return return_with(:error, access_token_gateway.error) unless access_token_gateway.success?
    return return_with(:error, ticket_gateway['errmsg']) unless success?
    return_with(:success, ticket: ticket)
  end

  private

    def success?
      !ticket_gateway['errcode'] || (ticket_gateway['errcode'] == 0)
    end

    def ticket
      ticket_gateway['ticket']
    end

    def ticket_gateway
      @ticket_gateway ||= Parser.get_json ticket_url
    end

    def ticket_url
      "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=#{type}"
    end

    def access_token_gateway
      @access_token_gateway ||= WechatApi::AccessToken.new.resolve
    end

    def access_token
      access_token_gateway.data[:access_token]
    end
end
