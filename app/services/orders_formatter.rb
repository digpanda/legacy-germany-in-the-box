# generate format for orders model (CSV for admin, ...)
class OrdersFormatter < BaseService

  CSV_LINE_CURRENCY = 'EUR'
  MAX_DESCRIPTION_CHARACTERS = 200
  HEADERS = ['Barcode ID', 'Merchant ID', 'Country ID', 'Item ID', 'HS Code', 'Description', 'Weight (g)', 'Price', 'Currency']

  def initialize(orders)
    @orders = orders
  end


  # convert a list of orders (model) into a normalized CSV file
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

  # TODO: CHANGE ORDER ITEM TO ORDERS IF NEEDED
  def csv_line(order_item)
    [
      order_item.order.border_guru_shipment_id,
      border_guru_merchant_id,
      order_item.sku.country_of_origin,
      order_item.sku.id, # Item ID
      order_item.product.hs_code, # HS Code
      "#{order_item.product.name}: #{order_item.product.decorate.clean_desc(MAX_DESCRIPTION_CHARACTERS)}", # Description
      (order_item.weight * 1000), # Weight : current_order_item.weight
      order_item.price, # Price
      CSV_LINE_CURRENCY # Currency
    ]
  end

end
