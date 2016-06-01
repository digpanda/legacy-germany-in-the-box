class UserDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if self.pic.url.nil?
     '/assets/icons/default_user_pic.png'
    else
      self.pic.url
    end
  end

  def reach_todays_limit?(new = 0)
    sum = self.orders.where(:status => :success).and(:u_ts.gte => Date.today, :u_ts.lt => Date.tomorrow).inject(0) { |sum, o| sum += o.decorate.total_price_in_curreny }
    sum + new <= Settings.instance.max_total_per_day
  end

  private

  def thumb_params
    Rails.configuration.logo_image_thumbnail
  end

  def detail_params
    Rails.configuration.logo_image_detailview
  end

end
