class UserDecorator < Draper::Decorator

  PICTURE_URL = '/images/icons/default_user_pic.png'
  
  include Imageable

  delegate_all
  decorates :user

  def reach_todays_limit?(order, new_price_increase)
    if today_paid_orders.size == 0
      false
    else
     (today_paid_orders_total_price + order.decorate.total_price_in_yuan + new_price_increase) > Settings.instance.max_total_per_day
    end
  end

  def today_paid_orders
    @today_paid_orders ||= orders.bought.and(:paid_at.gte => Date.today, :paid_at.lt => Date.tomorrow)
  end
    
  def today_paid_orders_total_price
    @today_paid_orders_total_price ||= todays_paid_orders.inject(0) { |sum, order| sum += order.decorate.total_price_in_yuan }
  end

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if pic.url.nil?
     PICTURE_URL
    else
      image_url(:pic, :thumb)
    end
  end

end
