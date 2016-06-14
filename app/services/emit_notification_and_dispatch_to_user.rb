class EmitNotificationAndDispatchToUser

  class << self

    def perform(args={})

      # Should be dynamic @yl
      user_id = args[:user_id]
      title  = args[:title]
      desc = args[:desc]

      notification = Notification.create({

        :user_id => user_id,
        :title => title,
        :desc => desc

      })

      self.dispatch_notification(notification) unless notification.errors.any?

    end

    def dispatch_notification(notification)

      #if notification.user.is_admin?
      #elsif notification.user.is_shopkeeper?
      #elsif notification.user.is_customer?
      #end

      UserMailer.notify(notification.user, notification.title, Rails.application.routes.url_helpers.shared_notifications_path).deliver_now

    end

  end

end