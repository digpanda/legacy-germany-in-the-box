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
    @today_paid_orders ||= orders.bought.where(:paid_at.gte => Date.today)
  end

  def today_paid_orders_total_price
    @today_paid_orders_total_price ||= today_paid_orders.inject(0) { |sum, order| sum += order.decorate.total_price_in_yuan }
  end

  # def reach_todays_limit?(order, new_price_increase)
  #   if today_paid_orders(order).size == 0
  #     false
  #   else
  #    (today_paid_orders_total_price(order) + order.decorate.total_price_in_yuan + new_price_increase) > Settings.instance.max_total_per_day
  #   end
  # end
  #
  # def today_paid_orders(order)
  #   @today_paid_orders ||= begin
  #     orders.bought.where(:paid_at.gte => Date.today).each.inject([]) do |memo, current_order|
  #       if order.shipping_address == current_order.shipping_address
  #         memo << order
  #       end
  #     end || []
  #   end
  # end
  #
  # def today_paid_orders_total_price(order)
  #   @today_paid_orders_total_price ||= begin
  #     today_paid_orders(order).inject(0) do |sum, current_order|
  #       sum += current_order.decorate.total_price_in_yuan
  #     end
  #   end
  # end

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

  def new_notifications?
    notifications.unreads.count > 0
  end

  def admin?
    self.role == :admin
  end

  def shopkeeper?
    self.role == :shopkeeper
  end

  def customer?
    self.role == :customer
  end

  # TODO : to remove when update of user will be refactored completely (shopkeeper and admin too)
  def update_with_password(params, *options)

    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
