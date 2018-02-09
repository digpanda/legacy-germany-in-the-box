class WechatTicket < BaseService
  attr_reader :cache_scope

  def initialize(cache_scope: '')
    @cache_scope = cache_scope
  end

  def resolve
    return return_with(:error, 'Cannot resolve ticket.') unless cached_ticket
    return_with(:success, ticket: cached_ticket.ticket)
  end

  private

    def cached_ticket
      weixin_ticket_cache || fresh_weixin_ticket_cache!
    end

    def fresh_weixin_ticket_cache!
      if weixin_api_ticket.success?
        WechatTicketCache.create(ticket: weixin_api_ticket.data[:ticket], cache_scope: cache_scope)
      end
    end

    def weixin_ticket_cache
      WechatTicketCache.still_valid.with_cache_scope(cache_scope).first
    end

    def weixin_api_ticket
      @weixin_api_tickrt ||= WechatApi::Ticket.new.resolve
    end
end
