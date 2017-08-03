require 'open-uri'

class Guest::ReferrersController < ApplicationController

  attr_accessor :referrer, :referrers

  authorize_resource class: false
  before_action :set_referrer

  def qrcode
    send_data Flyer.new.process_qrcode(qrcode_path).image.to_blob, :stream => "false", :filename => "qrcode.jpg", :type => "image/jpeg", :disposition => "inline"
  end

  private

  def qrcode_path
    if wechat_referrer_qrcode.success?
      wechat_referrer_qrcode.data[:local_file]
    end
  end

  def wechat_referrer_qrcode
    @wechat_referrer_qrcode ||= WechatReferrerQrcode.new(referrer).resolve!
  end

  def set_referrer
    @referrer = Referrer.find(params[:id] || params[:referrer_id])
  end

end
