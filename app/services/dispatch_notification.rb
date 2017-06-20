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

  def perform
    insert! if user
    dispatch!
  rescue Error => exception
    return_with(:error, exception.error)
  end

  def dispatch!
    mailer.notify(
      email: recipient_email,
      user: user,
      title: title,
      url: shared_notifications_path
    ).deliver_later(wait: 1.minutes)
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
    Notification.create({user: user, title: title, desc: desc}).tap do |notification|
      if notification.errors.any?
        raise Error, notification.errors.full_message.join(', ')
      end
    end
  end

end
