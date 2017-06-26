require 'csv'

# generate format for orders model (CSV for admin, ...)
class OrdersFormatter < BaseService

  include Rails.application.routes.url_helpers

  CSV_LINE_CURRENCY = 'EUR'
  MAX_DESCRIPTION_CHARACTERS = 200
  HEADERS = [
    'Order ID',
    'Customer',
    'Billing Address',
    'Status',
    'Description',
    'Clean Description',
    'Products',
    'Products descriptions',
    'Total Quantity',
    'Total Volume',
    'Total products price (EUR)',
    'Total products price (CNY)',
    'Shipping Cost (EUR)',
    'Shipping Cost (CNY)',
    'Tax and Duty Cost (EUR)',
    'Tax and Duty Cost (CNY)',
    'End price (EUR)',
    'End price (CNY)',
    'Coupon code',
    'Coupon discount',
    'Coupon discount (EUR)',
    'Coupon description',
    'Total paid (EUR)',
    'Total paid (CNY)',
    'Total items',
    'Merchant Id',
    'Payments IDs',
    'Payments Methods',
    'Transactions Types',
    'Transactions IDs',
    'Request IDs',
    'Bill ID',
    'Paid At',
    'Created At',
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

  def csv_line(order)
    [
      order.id,
      chinese_full_name(order),
      full_address(order),
      order.status,
      order.desc,

      order.decorate.clean_desc,
      order_item_names(order),

      order.decorate.clean_order_items_description,
      order.decorate.total_quantity,
      order.decorate.total_volume,

      order.decorate.total_price.in_euro.amount,
      order.decorate.total_price.in_euro.to_yuan.amount,
      order.decorate.shipping_cost.in_euro.amount,
      order.decorate.shipping_cost.in_euro.to_yuan.amount,
      order.decorate.taxes_cost.in_euro.amount,
      order.decorate.taxes_cost.in_euro.to_yuan.amount,
      order.decorate.end_price.in_euro.amount,
      order.decorate.end_price.in_euro.to_yuan.amount,

      (order.coupon ? order.coupon.code : ''),
      (order.coupon ? order.coupon.decorate.discount_display : ''),
      (order.coupon_discount ? order.coupon_discount : ''),
      (order.coupon ? order.coupon.desc : ''),

      order.total_paid(:eur),
      order.total_paid(:cny),
      order.order_items.count,

      (order.shop ? order.shop.merchant_id : ''),

      payments_ids(order),

      payment_methods(order),
      transaction_types(order),

      transactions_ids(order),
      requests_ids(order),

      order.bill_id,
      order.paid_at,
      order.c_at,
      order.u_at,
    ]
  end

  def order_item_names(order)
    order.order_items.reduce([]) { |acc, order_item| acc << order_item.product.name }.join(', ')
  end

  def chinese_full_name(order)
    order.billing_address.decorate.chinese_full_name if order.billing_address
  end

  def full_address(order)
    order.billing_address.decorate.full_address if order.billing_address
  end

  def payments_ids(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.id }.join(', ')
  end

  def requests_ids(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.request_id }.join(', ')
  end

  def transactions_ids(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.transaction_id }.join(', ')
  end

  def payment_methods(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.payment_method }.join(', ')
  end

  def transaction_types(order)
    order.order_payments.reduce([]) { |acc, order_payment| acc << order_payment.transaction_type }.join(', ')
  end

end
