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

    if notification.user.is_shopkeeper?
      ShopkeeperMailer.notify(notification.user, notification.title, shared_notifications_path).deliver_now
    elsif notification.user.is_customer?
      CustomerMailer.notify(notification.user, notification.title, shared_notifications_path).deliver_now
    end
  end

end