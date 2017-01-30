# manage the expenses and check if it reaches any limit, so we can buy it
# there a some cases involving this service
# - the user wants to buy more than 1000 YUAN in one order and it has more than 1 item in it
# - the user select an address matching with an ID which has already spent too much today
class BuyingBreaker < BaseService

  BUYING_LIMIT_CNY = Setting.instance.max_total_per_day # 1000

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # we check if he reached the limit
  # on adding up one item (sku) in this specific order
  # if there were not item before, it passes the limit (because it's one pricey item)
  def with_sku?(sku, quantity)
    return false if order.order_items.size == 0 && quantity == 1
    (sku.decorate.price_in_yuan * quantity + order_price) > BUYING_LIMIT_CNY
  end

  # we check if he reached the limit
  # after he selected an address
  # and we try to add up this order to the total for today
  # NOTE : the address must be a shipping_address
  # the comparison is made on the recipient of the package
  def with_address?(address)
    if address_today_paid(address) > 0
      (order_price + address_today_paid(address)) > BUYING_LIMIT_CNY
    end
  end

  private

  def order_price
    order.total_price_with_taxes.in_euro.to_yuan.amount
  end

  # TODO : we should refactor this and put it inside the model because it belongs to it
  # and its decorator
  def address_today_paid(address)
    address_today_orders(address).inject(0) do |sum, current_order|
      sum += current_order.total_price_with_taxes.in_euro.to_yuan.amount
    end
  end

  def address_today_orders(address)
    @address_today_orders ||= begin
      today_paid_orders.each.inject([]) do |memo, current_order|
        if address == current_order.shipping_address
          memo << current_order
        end
      end || []
    end
  end

  def orders
    @orders ||= order.user.orders
  end

  def today_paid_orders
    @today_paid_orders ||= orders.bought.where(:paid_at.gte => Date.today)
  end

end
