# send an email from the notifier dispatcher
class Notifier
  class Dispatcher
    class Sms

      attr_reader :dispatcher

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        SlackDispatcher.new.message("DISPATCHING RIGHT NOW ON MOBILE `#{recipient_mobile}` WITH MESSAGE `#{dispatcher.desc}`")
        messenger.send(recipient_mobile, dispatcher.desc)
      rescue Twilio::REST::RequestError => exception
        SlackDispatcher.new.message("ERROR WAS TRIGGERED #{exception.message}")
        raise Notifier::Error, exception.message
      end

      private

      def messenger
        @messenger ||= PhoneMessenger.new
      end

      def recipient_mobile
        dispatcher.user.mobile
      end

    end
  end
end
