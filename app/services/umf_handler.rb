class UmfHandler < BaseService
  ACCOUNT_NUMBER = '50898'.freeze

  include ArrayHelper

  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end

  # we generate the txt for UMF
  def text
    hashes.reduce([]) do |acc, order|
      acc << order.values.join('|')
    end.join("\r\n")
  end

  def hashes
    orders.reduce([]) do |acc, order|
      acc << {
        customer_account_number: ACCOUNT_NUMBER,
        business_sector: solve_business_sector(order),
        business_subsector: solve_business_subsector(order),
        order_number: order.id,
        order_currency_foreign_currency: 'EUR',
        placeholder: '',
        order_amount_rmb: solve_order_amount_rmb(order),
        order_date: solve_order_date(order),
        order_time: solve_order_time(order),
        transaction_date: solve_order_date(order), # same as order for now
        transaction_time: solve_order_time(order), # same as order for now
        products_and_logistics_info: solve_products_and_logistics_info(order),
        payer_name: order.shipping_address&.decorate&.full_name,
        payer_id_number: order.shipping_address&.pid,
        shipping_tracking_number: order.order_tracking&.delivery_id,
        payer_phone_number: solve_payer_phone_number(order),
        customs_clearance: 'N',
        payer_account_id: '',
        transaction_number: '',
        ecommerce_platform_number: '',
        product_price: '',
        product_tax: '',
        product_shipping_cost: '',
        customs_code: '',
        product_total_price: ''
      }
    end
  end

  private

  # `+` and such should be removed
  def solve_payer_phone_number(order)
    raw = order.shipping_address&.mobile
    if raw&.first == '+'
      raw = raw.slice(3,raw.length)
    end
    raw
  end

  # the amount should be a whole number (cent is taken as unit)
  def solve_order_amount_rmb(order)
    (order.total_paid(:cny) * 100).to_i
  end

  # names of products in this order, and the name of the shipping company
  def solve_products_and_logistics_info(order)
    readable_products = order.order_items.reduce([]) { |acc, order_item| acc << order_item.product.name }.join(',')
    readable_logistic = delivery_providers.select{|key, hash| hash == order.order_tracking&.delivery_provider&.to_sym }.keys.join(',')
    "#{readable_products},#{readable_logistic}"
  end

  # hhmmss
  def solve_order_time(order)
    order.paid_at&.strftime('%H%M%S')
  end

  # yyyyMMdd
  def solve_order_date(order)
    order.paid_at&.strftime('%Y%m%d')
  end

  #  if the package is sent by EMS guoji, the the code should be 01122030; if the packages is sent in other way, then the code should be 01121990.
  def solve_business_sector(order)
    if order.order_tracking&.delivery_provider == :emsguoji
      '01122030'
    else
      '01121990'
    end
  end

  # for cloths should type in 1, for foodstuff should type in 2, for electronic products should type in 3, for other products is 4
  # NOTE : not doable programmatically.
  def solve_business_subsector(order)
    '4'
  end

end
