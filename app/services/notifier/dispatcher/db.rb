# send an email from the notifier dispatcher
class Notifier
  class Dispatcher
    class Db
      attr_reader :dispatcher

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        raise_insertion_error?
        insert_notification!
      end

      private

        def insert_notification!
          Notification.create(
            user: dispatcher.user,
            title: dispatcher.title,
            desc: dispatcher.desc,
            scope: dispatcher.scope,
            unique_id: dispatcher.unique_id,
            metadata: dispatcher.metadata
          ).tap do |notification|
            if notification.errors.any?
              raise Notifier::Error, notification.errors.full_messages.join(', ')
            end
          end
        end

        def raise_insertion_error?
          raise Notifier::Error, 'This notification was already sent.' if already_notified?
        end

        def already_notified?
          notified_by_content? || notified_by_unique_id?
        end

        def notified_by_content?
          Notification.where(user: dispatcher.user, title: dispatcher.title, desc: dispatcher.desc).count > 0
        end

        def notified_by_unique_id?
          if dispatcher.unique_id
            Notification.where(user: dispatcher.user, unique_id: dispatcher.unique_id).count > 0
          end
        end
    end
  end
end
