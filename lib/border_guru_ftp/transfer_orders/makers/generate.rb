require 'csv'

module BorderGuruFtp
  class TransferOrders
    module Makers
      class Generate < Base

        CSV_LINE_CURRENCY = 'EUR'
        MAX_DESCRIPTION_CHARACTERS = 240
        HEADERS = ['Barcode ID', 'Merchant ID', 'Country ID', 'Item ID', 'HS Code', 'Description', 'Weight (g)', 'Price', 'Currency']

        def to_csv
          CSV.generate do |csv|
            csv << HEADERS
            orders.each do |order|
              order.order_items.each do |order_item|
                csv << csv_line(order_item)
              end
            end
          end
        end

        private

        def csv_line(order_item)
          [
            order_item.order.border_guru_shipment_id,
            border_guru_merchant_id,
            CONFIG[:products][:origin],      
            order_item.sku.id, # Item ID
            order_item.product.hs_code, # HS Code
            order_item.product.decorate.clean_desc(MAX_DESCRIPTION_CHARACTERS), # Description
            (order_item.weight * 1000), # Weight : current_order_item.weight
            order_item.price, # Price
            CSV_LINE_CURRENCY # Currency
          ]
        end

      end
    end
  end
end
