class WeixinTicket < BaseService
  def initialize
  end

  def resolve!
    return return_with(:error, "Cannot resolve ticket.") unless cached_ticket
    return_with(:success, ticket: cached_ticket)
  end

  private

  def cached_ticket
    weixin_ticket_cache || fresh_weixin_ticket_cache!
  end

  def fresh_weixin_ticket_cache!
    if weixin_api_ticket.success?
      WeixinTicketCache.create(ticket: weixin_api_ticket.data[:ticket])
    end
  end

  def weixin_ticket_cache
    WeixinTicketCache.still_valid.first
  end

  def weixin_api_ticket
    WeixinApiTicket.new.resolve!
  end

end
