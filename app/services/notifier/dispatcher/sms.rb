# send an email from the notifier dispatcher
class Notifier
  class Dispatcher
    class Sms

      attr_reader :dispatcher

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        binding.pry
        messenger.send(recipient_mobile, dispatcher.desc)
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
