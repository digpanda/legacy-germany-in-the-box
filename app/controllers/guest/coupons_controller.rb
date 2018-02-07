class Guest::CouponsController < ApplicationController
  attr_reader :coupon, :coupons

  before_action :set_coupon

  def flyer
    send_data blob_flyer, stream: 'false', filename: 'qrcode.jpg', type: 'image/jpeg', disposition: 'inline'
  end

  private

    def blob_flyer
      if qrcode_path
        Flyer.new.process_steps(coupon, qrcode_path).image.to_blob
      else
        Magick::ImageList.new(fallback_image).to_blob
      end
    end

    def qrcode_path
      if coupon.referrer
        if wechat_referrer_qrcode.success?
          return wechat_referrer_qrcode.data[:local_file]
        end
      end
    end

    def wechat_referrer_qrcode
      @wechat_referrer_qrcode ||= WechatReferrerQrcode.new(coupon.referrer).resolve
    end

    def set_coupon
      @coupon = Coupon.find(params[:id] || params[:coupon_id])
    end

    def fallback_image
      "#{Rails.root}/public/images/no_image_available.jpg"
    end
end
