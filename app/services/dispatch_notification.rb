#
# Emit a notification and set the correct model
# Then dispatch the notification to the user email
#
class DispatchNotification < BaseService

  include Rails.application.routes.url_helpers

  def initialize(email:nil,user:nil,title:nil,desc:nil)
    @email = email
    @user = user
    @title = title
    @desc = desc
  end

  def perform(dispatch:[:email])
    insert! if user
    email! if dispatch.include? :email
    sms! if dispatch.include? :sms
    return_with(:success)
  rescue Error => exception
    return_with(:error, exception.error)
  end

  def email!
    mailer.notify(
      recipient_email: recipient_email,
      user_id: user.id.to_s,
      title: title,
      url: shared_notifications_path
    ).deliver_later(wait: 1.minutes)
  end

  def sms!
    # TODO
  end

  private

  def mailer
    if user.customer?
      CustomerMailer
    elsif user.shopkeeper?
      ShopkeeperMailer
    elsif user.admin?
      AdminMailer
    end
  end

  def recipient_email
    email || user.email
  end

  def insert!
    raise Error, "This notification was already sent." if already_notified?
    Notification.create({user: user, title: title, desc: desc}).tap do |notification|
      if notification.errors.any?
        raise Error, notification.errors.full_message.join(', ')
      end
    end
  end

  def already_notified?
    Notification.where(user: user, title: title, desc: desc).count > 0
  end

end
