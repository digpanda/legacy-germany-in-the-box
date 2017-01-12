class ShopkeeperMailer < ApplicationMailer

   default from: 'no-reply@germanyinthebox.com'
   layout 'mailers/shopkeeper'

  def notify(user_id, title, url)
    @user = User.find(user_id)
    @title = title
    @url = url
    mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}") # @user.email
  end

   def notify_order_not_sent(order_id, user_id, title, desc, url)
     @order = Order.find(order_id)
     @user = User.find(user_id)
     @title = title
     @url = url

    if @order.status == :custom_checkable
      Notification.create(user_id: @user.id, title: title, desc: desc)
      EmitNotificationAndDispatchToUser.new.perform_if_not_sent_to_admin({
                                                                    order: @order,
                                                                    title: "Auftrag #{@order.id} am #{@order.paid_at}",
                                                                    desc: "Der Shop-Besitzer #{@order.shop.shopkeeper.id} hat die Bestellung #{@order.id} noch nicht gesendet."
                                                                })
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
       EmitNotificationAndDispatchToUser.new.perform_if_not_selected_sent_to_admin({
                                                                              order: @order,
                                                                              title: "Auftrag #{@order.id} am #{@order.paid_at}",
                                                                              desc: "Der Shop-Besitzer #{@order.shop.shopkeeper.id} hat 'Das Paket wurde versandt' noch nicht fur die Bestellung #{@order.id} geklickt."
                                                                          })
       mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}", template_name: 'notify')
     end
   end
end
