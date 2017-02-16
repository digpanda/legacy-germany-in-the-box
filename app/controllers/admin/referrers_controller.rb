class Admin::ReferrersController < ApplicationController

  attr_accessor :referrer, :referrers

  before_action :set_referrer, :except => [:index, :new]

  authorize_resource :class => false
  layout :custom_sublayout

  def index
    @referrers = User.with_referrer
  end

  def new
    @referrer_token = ReferrerToken.create
    @url = "https://open.weixin.qq.com/connect/oauth2/authorize?" +
        "appid=#{Rails.application.config.wechat[:username_mobile]}&" +
        "redirect_uri=http%3A%2F%2Fgermanyinbox.com/connect/auth/referrer?" +
        "token=#{@referrer_token.token}" +
        "&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect"
end

  def coupon
    coupon = Coupon.create({
      :code => SecureRandom.hex(5),
      :unit => :percent,
      :discount => Setting.instance.referrers_rate,
      :minimum_order => 0,
      :unique => false,
      :desc => 'Referrer Coupon',
      :referrer => referrer,
      :exclude_china => true
    })
    if coupon
      flash[:success] = "The coupon was created."
    else
      flash[:error] = "The coupon was not created (#{coupon.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def set_referrer
    @referrer = User.find(params[:id] || params[:referrer_id])
  end

end
