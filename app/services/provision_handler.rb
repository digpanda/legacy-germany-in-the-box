class ProvisionHandler

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def refresh!
    SlackDispatcher.new.message("HANDLING PROVISION HANDLER")
    if order.referrer && order.bought?
      SlackDispatcher.new.message("WE WILL ENSURE THE PROVISION NOW")
      ensure!
    else # cancel case, we will change that later on
      delete!
    end
  end

  def ensure!
    SlackDispatcher.new.message("CURRENT PROVISION : #{current_provision}")
    referrer_provision.provision = current_provision
    referrer_provision.save
  end

  def delete!
    referrer_provision.delete
  end

  private

  def referrer_provision
     @referrer_provision ||= ReferrerProvision.where(order: order, referrer: order.referrer).first || ReferrerProvision.create(order: order, referrer: order.referrer)
  end

  # live referrer provision before it's saved in the database
  def current_provision
    order.order_items.reduce(0) do |acc, order_item|
      if order_item.referrer_rate > 0.0
        # it's the total price minus the normalized coupon discount
        calculation_price = order_item.total_price * ((100 - order.coupon_discount_in_percent) / 100)
        acc += calculation_price * order_item.referrer_rate / 100 # goods price
      else
        acc += 0.0
      end
    end
  end

end
