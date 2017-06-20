class Notifier
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
end
