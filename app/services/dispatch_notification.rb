#
# Emit a notification and set the correct model
# Then dispatch the notification to the user email
#
class DispatchNotification < BaseService

  include Rails.application.routes.url_helpers

  def initialize
  end

  # TODO : should use keyword arguments instead
  def perform(args={})
    # Should be dynamic @yl
    user = args[:user]
    title  = args[:title]
    desc = args[:desc]

    notification = Notification.create({
                                           user_id: user.id,
                                           title: title,
                                           desc: desc
                                       })

    if notification.errors.any?
      return_with(:error, notification.errors.full_message.join(', '))
    else
      dispatch_notification(notification) and return_with(:success)
    end
  end

  def dispatch_notification(notification)
    if notification.user.decorate.shopkeeper?
      ShopkeeperMailer.notify(notification.user.id.to_s, notification.title, shared_notifications_path).deliver_later(wait: 1.minutes)
    elsif notification.user.decorate.customer?
      CustomerMailer.notify_template(notification.user.id.to_s, notification.title, shared_notifications_path).deliver_later(wait: 1.minutes)
    end
  end

  def perform_if_not_sent(args={})
    order = args[:order]
    user = args[:user]
    title  = args[:title]
    desc = args[:desc]
    ShopkeeperMailer.notify_order_not_sent(order.id.to_s, user.id.to_s, title, desc, shared_notifications_path).deliver_later(wait: get_deliver_time(2.business_days.from_now))
  end

  def perform_if_not_selected_sent(args={})
    order = args[:order]
    user = args[:user]
    title  = args[:title]
    desc = args[:desc]
    ShopkeeperMailer.notify_order_not_sent_selected(order.id.to_s, user.id.to_s, title, desc, shared_notifications_path).deliver_later(wait: get_deliver_time(2.business_days.from_now))
  end

  def perform_if_not_sent_to_admin(args={})
    order = args[:order]
    title  = args[:title]
    desc = args[:desc]
    User.admins.each do |user|
      AdminMailer.notify_order_not_sent(order.id.to_s, user.id.to_s, title, desc, shared_notifications_path).deliver_later(wait: get_deliver_time(1.business_days.from_now))
    end
  end

  def perform_if_not_selected_sent_to_admin(args={})
    order = args[:order]
    title  = args[:title]
    desc = args[:desc]
    User.admins.each do |user|
      AdminMailer.notify_order_not_sent_selected(order.id.to_s, user.id.to_s, title, desc, shared_notifications_path).deliver_later(wait: get_deliver_time(1.business_days.from_now))
    end
  end

  private

  def get_deliver_time(deliver_date)
    deliver_date.to_time - Time.now
  end
end
