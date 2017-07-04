class Notifier
  class Shopkeeper < Notifier

    include Rails.application.routes.url_helpers
    
    attr_reader :user, :unique_id

    def initialize(user, unique_id:nil)
      @user = user
      @unique_id = unique_id
    end

    def welcome
      dispatch(
        title: 'Wilkommen bei Germany In The Box !',
        desc: "Vielen Dank für Ihren Antrag. Wir werden uns bald mit Ihnen in Verbindung setzten."
      ).perform
    end

    def sku_quantity_is_low(order_item, sku)
      dispatch(
        title: "Die Verfügbarkeit eines Produkts ist fast Null",
        desc: "Das Produkt '#{order_item.product&.name}' verfügt über #{sku.quantity} Verfügbarkeit.",
        url: shopkeeper_product_skus_path(product_id: sku.product.id)
      ).perform
    end

    def order_was_paid(order)
      dispatch(
        title: "Auftrag #{order.id} am #{order.paid_at}",
        desc: "Eine neue Bestellung ist da. Zeit für die Vorbereitung!"
      ).perform
    end

  end
end
