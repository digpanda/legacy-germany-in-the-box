require 'csv'

# take a succession of `orders` and turn it into a CSV file for BorderGuru
# can be extended to other format also
module BorderGuruFtp
  class TransferOrders
    module Makers
      class Generate < Base

        CSV_LINE_CURRENCY = 'EUR'
        HEADERS = ['Barcode ID', 'Merchant ID',  'Item ID',  'HS Code', 'Country of Manufacture', 'Product Variable', 'Article Description', 'Net Weight in g', 'Price in EUR', 'Currency']

        # convert a list of orders (model) into a normalized CSV file
        # for BorderGuru to process them afterwards
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
            order_item.sku_origin.id, # Origin SKU ID
            order_item.product.hs_code, # HS Code
            order_item.sku.country_of_origin,
            order_item.sku.display_option_names, # Description
            order_item.clean_desc, # Description
            (order_item.weight * 1000), # Weight : current_order_item.weight
            order_item.sku.decorate.price_after_discount_in_euro, # Price
            CSV_LINE_CURRENCY # Currency
          ]
        end

      end
    end
  end
end
