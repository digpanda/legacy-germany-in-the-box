# manage the expenses and check if it reaches any limit
# there a some cases involving this service
# - the user wants to buy more than 1000 YUAN in one order and it has more than 1 item in it
# - the user select an address matching with an ID which has already spent too much today
class BuyingBreaker < BaseService

  BUYING_LIMIT = Settings.instance.max_total_per_day # 1000

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # we check if he reached the limit
  # on adding up one item in this specific order
  def per_order?(order_item)
    if (order_item.price + order.decorate.total_price_in_yuan) > BUYING_LIMIT
      true
    else
      false
    end
  end

  # we check if he reached the limit
  # after he selected an address
  # NOTE : the address must be a shipping_address
  # the comparison is made on the recipient of the package
  def per_address?(address)
    # TODO : we need to abstract this into another class (obviously, Address)
    if address_today_paid(address) > BUYING_LIMIT
      true
    else
      false
    end
  end

  private

  def address_today_paid(address)
    address_today_orders(address).inject(0) do |sum, current_order|
      sum += current_order.decorate.total_price_in_yuan
    end
  end

  def address_today_orders(address)
    @address_today_orders ||= begin
      today_paid_orders.each.inject([]) do |memo, current_order|
        if address == current_order.shipping_address
          memo << order
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
