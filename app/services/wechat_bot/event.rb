module WechatBot
  class Event < Base
    attr_reader :user, :event, :event_key

    def initialize(user, event, event_key)
      @user = user
      @event = event.downcase
      @event_key = event_key # no downcase here as it depends on the different area to downcase or not
    end

    def dispatch
      case event
      when 'scan'
        Scan.new(user, event_key).handle
      when 'click'
        Click.new(user, event_key).handle
      when 'subscribe'
        SlackDispatcher.new.message("SUBSCRBE EVENT WAS TRIGGERED")
        Subscribe.new(user).handle
      else
        # in case it's not understood by the system
        # we return a success anyway
        return_with(:success)
      end
    rescue WechatBot::Error => exception
      return_with(:error, error: exception.message)
    end

  end
end
