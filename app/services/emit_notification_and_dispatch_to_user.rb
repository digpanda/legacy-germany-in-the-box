#
# Emit a notification and set the correct model
# Then dispatch the notification to the user email
#
class EmitNotificationAndDispatchToUser < BaseService

  include Rails.application.routes.url_helpers

  def initialize
  end

  def perform(args={})

    # Should be dynamic @yl
    user = args[:user]
    title  = args[:title]
    desc = args[:desc]

    notification = Notification.create({

      :user_id => user.id,
      :title => title,
      :desc => desc

      })

    if notification.errors.any?
      return_with(:error, notification.errors.full_message.join(', '))
    else
      dispatch_notification(notification) and return_with(:success)
    end

  end

  def dispatch_notification(notification)

    if notification.user.decorate.shopkeeper?
      ShopkeeperMailer.notify(notification.user, notification.title, shared_notifications_path).deliver_later
    elsif notification.user.decorate.customer?
      CustomerMailer.notify(notification.user, notification.title, shared_notifications_path).deliver_later
    end
  end

end
