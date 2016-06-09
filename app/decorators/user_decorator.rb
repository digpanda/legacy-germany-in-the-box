class UserDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if self.pic.url.nil?
     '/images/icons/default_user_pic.png'
    else
      self.pic.url
    end
  end

  def reach_todays_limit?(new = 0)
    todays_orders = self.orders.where(:status => :success).and(:u_at.gte => Date.today).and(:u_at.lt => Date.tomorrow)
    todays_orders.size == 0 ? false : (todays_orders.inject(0) { |sum, o| sum += o.decorate.total_price_in_currency } + new) > Settings.instance.max_total_per_day
  end

  private

  def thumb_params
    Rails.configuration.logo_image_thumbnail
  end

  def detail_params
    Rails.configuration.logo_image_detailview
  end

end
