# send an email from the notifier dispatcher
class Notifier
  class Dispatcher
    class Sms

      attr_reader :dispatcher

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        messenger.send(recipient_mobile, dispatcher.desc)
      rescue Twilio::REST::RequestError => exception
        raise Notifier::Error, exception.message
      end

      private

      def messenger
        @messenger ||= PhoneMessenger.new
      end

      def recipient_mobile
        dispatcher.mobile || dispatcher.user.mobile
      end

    end
  end
end
