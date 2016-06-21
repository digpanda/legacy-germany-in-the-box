#
# Emit a notification and set the correct model
# Then dispatch the notification to the user email
#
class EmitNotificationAndDispatchToUser < BaseService

  def initialize 
  end

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

    if notification.errors.any?
      return_with(:error, notification.errors.full_message.join(', '))
    else
      dispatch_notification(notification) and return_with(:success)
    end

  end

  def dispatch_notification(notification)

    #if notification.user.is_admin?
    #elsif notification.user.is_shopkeeper?
    #elsif notification.user.is_customer?
    #end

    UserMailer.notify(notification.user, notification.title, Rails.application.routes.url_helpers.shared_notifications_path).deliver_now

  end

end