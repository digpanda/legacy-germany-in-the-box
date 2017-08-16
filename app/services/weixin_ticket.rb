class WeixinTicket < BaseService
  attr_reader :scope

  def initialize(scope: nil)
    @scope = scope
  end

  def resolve!
    return return_with(:error, "Cannot resolve ticket.") unless cached_ticket
    return_with(:success, ticket: cached_ticket.ticket)
  end

  private

  def cached_ticket
    weixin_ticket_cache || fresh_weixin_ticket_cache!
  end

  def fresh_weixin_ticket_cache!
    if weixin_api_ticket.success?
      WeixinTicketCache.create(ticket: weixin_api_ticket.data[:ticket], scope: scope)
    end
  end

  def weixin_ticket_cache
    WeixinTicketCache.still_valid.with_scope(scope).first
  end

  def weixin_api_ticket
    WeixinApiTicket.new.resolve!
  end
end
