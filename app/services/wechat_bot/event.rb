class WechatBot
  class Event < Base
    attr_reader :user, :event, :event_key

    def initialize(user, event, event_key)
      @user = user
      @event = event
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
      end
    rescue WechatBot::Error => exception
      return_with(:error, error: exception.message)
    end

  end
end
