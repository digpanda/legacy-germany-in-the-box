class AdminMailer < ApplicationMailer

  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/shopkeeper'

  def notify_claim_money(email, referrer_id)
    @referrer = Referrer.find(referrer_id)
    mail(to: email, subject: "Referrer claimed money", template_name: 'claim_money')
  end

  def notify_order_not_sent(order_id, user_id, title, desc, url)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    @title = title
    @url = url

    if @order.status == :paid
      Notification.create(user_id: @user.id, title: title, desc: desc)
      mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}", template_name: 'notify')
    end
  end

  def notify_order_not_sent_selected(order_id, user_id, title, desc, url)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    @title = title
    @url = url

    if @order.status != :shipped
      Notification.create(user_id: @user.id, title: title, desc: desc)
      mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}", template_name: 'notify')
    end
  end
end
