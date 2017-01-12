class AdminMailer < ApplicationMailer

  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/shopkeeper'

  def notify_order_not_sent(order_id, user_id, title, desc, url)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    @title = title
    @url = url

    if @order.status == :custom_checkable
      Notification.create(user_id: @user.id, title: title, desc: desc)
      mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}", template_name: 'shopkeeper_mailer/notify')
    end
  end

  def notify_order_not_sent_selected(order_id, user_id, title, desc, url)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    @title = title
    @url = url

    if @order.status != :shipped
      Notification.create(user_id: @user.id, title: title, desc: desc)
      mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}", template_name: 'shopkeeper_mailer/notify')
    end
  end
end
