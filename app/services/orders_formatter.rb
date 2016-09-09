require 'csv'

# generate format for orders model (CSV for admin, ...)
class OrdersFormatter < BaseService

  CSV_LINE_CURRENCY = 'EUR'
  MAX_DESCRIPTION_CHARACTERS = 200
  HEADERS = [
    'Order ID',
    'Customer',
    'Billing Address',
    'Status',
    'Description',
    'Clean Description',
    'Clean Description with Order Items',
    'Total Quantity',
    'Total Volume',
    'Total products price (EUR)',
    'Total products price (CNY)',
    'Shipping Cost (EUR)',
    'Shipping Cost (CNY)',
    'Tax and Duty Cost (EUR)',
    'Tax and Duty Cost (CNY)',
    'Total price (EUR)',
    'Total price (CNY)',
    'BorderGuru Quote ID',
    'BorderGuru Shipment ID',
    'BorderGuru Link Tracking',
    'BorderGuru Link Payment',
    'Payments IDs',
    'Wirecard Transactions IDs',
    'Minimum Sending Date',
    'Hermes Pickup Email Sent At',
    'Bill ID',
    'Paid At',
    'Ceeated At',
    'Updated At',
  ]

  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end


  # convert a list of orders (model) into a normalized CSV file
  def to_csv
    CSV.generate do |csv|
      csv << HEADERS
      orders.each do |order|
        csv << csv_line(order)
      end
    end
  end

  private

  # TODO: we shouldn't show the currency symbol sometimes,
  # we should refactor the whole model for it
  def csv_line(order)
    [
      order.id,
      order.decorate.chinese_full_name,
      order.billing_address.decorate.full_address,
      order.status,
      order.desc,
      order.decorate.clean_desc,
      order.decorate.clean_order_items_description,
      order.decorate.total_quantity,
      order.decorate.total_volume,
      order.decorate.total_price_with_currency_euro,
      order.decorate.total_price_with_currency_yuan,
      order.decorate.shipping_cost_with_currency_euro,
      order.decorate.shipping_cost_with_currency_yuan,
      order.decorate.tax_and_duty_cost_with_currency_euro,
      order.decorate.tax_and_duty_cost_with_currency_yuan,
      order.decorate.total_sum_in_euro,
      order.decorate.total_sum_in_yuan,
      order.border_guru_quote_id,
      order.border_guru_shipment_id,
      order.border_guru_link_tracking,
      order.border_guru_link_payment,
      payments_ids(order),
      wirecard_transactions_ids(order),
      order.minimum_sending_date,
      order.hermes_pickup_email_sent_at,
      order.bill_id,
      order.paid_at,
      order.c_at,
      order.u_at,
    ]
  end
  def payments_ids(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.id }.join(', ')
  end

  def wirecard_transactions_ids(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.transaction_id }.join(', ')
  end

end
