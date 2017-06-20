# send an email from the notifier dispatcher
class Notifier
  class Dispatcher
    class Email

      attr_reader :dispatcher

      include Rails.application.routes.url_helpers

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        mailer.notify(
          recipient_email: recipient_email,
          user_id: dispatcher.user.id.to_s,
          title: dispatcher.title,
          url: link_url,
        ).deliver_later(wait: 1.minutes)
      end

      private

      def mailer
        if dispatcher.user.customer?
          CustomerMailer
        elsif dispatcher.user.shopkeeper?
          ShopkeeperMailer
        elsif dispatcher.user.admin?
          AdminMailer
        end
      end

      def link_url
        dispatcher.url || shared_notifications_path
      end

      def recipient_email
        dispatcher.email || dispatcher.user.email
      end

    end
  end
end
