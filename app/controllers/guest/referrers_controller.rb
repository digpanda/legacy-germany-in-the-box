class Guest::ReferrersController < ApplicationController

  attr_accessor :referrer, :referrers

  authorize_resource :class => false
  before_action :set_referrer

  # this is a rendered image to show on the referrer area
  # but it can be seen by anyone so they can communicate it more easily
  def qrcode
    send_data qrcode_image.to_blob, :stream => "false", :filename => "test.jpg", :type => "image/jpeg", :disposition => "inline"
  end

  private

  def qrcode_image
    if wechat_referrer_qrcode.success?
      wechat_referrer_qrcode.data[:qrcode]
    end
  end

  def wechat_referrer_qrcode
    @wechat_referrer_qrcode ||= WechatReferrerQrcode.new(referrer).resolve!
  end

  def set_referrer
    @referrer = Coupon.find(params[:id] || params[:referrer_id])
  end

end
