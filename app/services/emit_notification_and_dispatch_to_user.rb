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

      UserMailer.notify(notification.user, notification.title, shared_notifications_path(:user_info_edit_part => :edit_notification)).deliver_now

    end

  end

end