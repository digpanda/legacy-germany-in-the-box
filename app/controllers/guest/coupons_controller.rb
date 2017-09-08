class Guest::CouponsController < ApplicationController
  attr_accessor :coupon, :coupons

  before_action :set_coupon

  def flyer
    send_data Flyer.new.process_steps(coupon, qrcode_path).image.to_blob, stream: 'false', filename: 'test.jpg', type: 'image/jpeg', disposition: 'inline'
  end

  private

    def qrcode_path
      if coupon.referrer
        if wechat_referrer_qrcode.success?
          wechat_referrer_qrcode.data[:local_file]
        end
      end
    end

    def wechat_referrer_qrcode
      @wechat_referrer_qrcode ||= WeixinReferrerQrcode.new(coupon.referrer).resolve!
    end

    def set_coupon
      @coupon = Coupon.find(params[:id] || params[:coupon_id])
    end
end
