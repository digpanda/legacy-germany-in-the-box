class OrderDecorator < Draper::Decorator

  delegate_all
  decorates :order

  def reach_todays_limit?(new_total = 0, new_quantity = 0)
    object.order_items.size == 0 ? (new_quantity == 0 ? false : new_total > Settings.instance.max_total_per_day ) : (new_quantity == 0 ? false :(total_price_in_currency + new_total) > Settings.instance.max_total_per_day)
  end

  def total_price_in_currency
    object.total_price * Settings.instance.exchange_rate_to_yuan
  end

  def total_price_with_currency
    "%.2f#{Settings.instance.platform_currency}" % total_price_in_currency
  end

  def is_success?
    self.status == :success
  end

end