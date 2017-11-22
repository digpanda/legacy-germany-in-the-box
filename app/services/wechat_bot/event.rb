module WechatBot
  class Event < Base
    attr_reader :user, :event, :event_key

    def initialize(user, event, event_key)
      @user = user
      @event = event
      SlackDispatcher.new.message("EVENT KEY : #{event_key}")
      @event_key = event_key
    end

    def dispatch
      case event
      when 'scan'
        Scan.new(user, event_key).handle
      when 'click'
        Click.new(user, event_key).handle
      when 'subscribe'
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
