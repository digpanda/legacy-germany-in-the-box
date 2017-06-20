class Notifier

   class Admin

     def initialize
     end

     def referrer_claimed_money(referrer)
       DispatchNotification.new(
        email: "info@digpanda.com",
        title: "Referrer #{referrer.reference_id}",
        desc: "This referrer claimed money. Please check his account and process operations if needed."
       ).perform
     end

   end

   class Shopkeeper

     attr_reader :shopkeeper

     def initialize(shopkeeper)
       @shopkeeper = shopkeeper
     end

     def welcome
       DispatchNotification.new(
        user: shopkeeper,
        title: 'Wilkommen bei Germany In The Box !',
        desc: "Vielen Dank für Ihren Antrag. Wir werden uns bald mit Ihnen in Verbindung setzten."
       ).perform
     end

    def sku_quantity_is_low(order_item, sku)
      DispatchNotification.new(
        user: shopkeeper,
        title: "Die Verfügbarkeit eines Produkts ist fast Null",
        desc: "Das Produkt '#{order_item.product&.name}' verfügt über #{sku.quantity} Verfügbarkeit."
      ).perform
    end

    def order_was_paid(order)
      DispatchNotification.new(
        user: shopkeeper,
        title: "Auftrag #{order.id} am #{order.paid_at}",
        desc: "Eine neue Bestellung ist da. Zeit für die Vorbereitung!"
      ).perform
    end

  end

  class Customer

    attr_reader :customer

    def initialize(customer)
      @customer = customer
    end

    def welcome
      DispatchNotification.new(
        user: customer,
        title: '注册成功，欢迎光临来因盒！',
        desc: "亲，欢迎你到来因盒购物。"
      )
    end

    def order_was_paid(order)
      DispatchNotification.new.perform(
        user: customer,
        title: "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
        desc: "你好，你的订单#{order.id}已成功付款，已通知商家准备发货。若有疑问，欢迎随时联系来因盒客服：customer@germanyinthebox.com。"
      )
    end

    def order_is_being_processed(order)
      DispatchNotification.new(
        user: customer,
        title: '你的订单已出货',
        desc: "你的订单已被商家寄出"
      )
    end

  end

end
