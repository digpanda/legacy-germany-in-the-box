require 'open-uri'

class Guest::ReferrersController < ApplicationController
  attr_reader :referrer, :referrers

  before_action :set_referrer

  def qrcode
    send_data Flyer.new.process_qrcode(qrcode_path, logo_path: qrcode_logo).image.to_blob, stream: 'false', filename: 'qrcode.jpg', type: 'image/jpeg', disposition: 'inline'
  end

  private

    def qrcode_logo
      if referrer.customization&.active && referrer.customization.logo.url
        "#{Rails.root}/public#{referrer.customization.logo.url}"
      else
        "#{Rails.root}/public/images/logo.png"
      end
    end

    # the qrcode will be from wechat if its our service
    # if the referrer has a customized site we will
    # generate the qrcode to go to the site directly
    def qrcode_path
      if referrer.customization&.active
        url_with_reference = guest_package_sets_url(reference_id: referrer&.reference_id)
        force_login_url = WechatUrlAdjuster.new(url_with_reference).adjusted_url
        qrcode_path = SmartQrcode.new(force_login_url).perform
        return "#{Rails.root}/public/#{qrcode_path}"
      else
        if wechat_referrer_qrcode.success?
          return wechat_referrer_qrcode.data[:local_file]
        end
      end
    end

    def wechat_referrer_qrcode
      @wechat_referrer_qrcode ||= WeixinReferrerQrcode.new(referrer).resolve
    end

    def set_referrer
      @referrer = Referrer.find(params[:id] || params[:referrer_id])
    end
end
