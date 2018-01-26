class Guest::BrandsController < ApplicationController
  attr_reader :brand

  before_filter do
    restrict_to :customer
  end

  before_action :set_brand

  def promote_qrcode
    send_data blob_qrcode, stream: 'false', filename: 'qrcode.jpg', type: 'image/jpeg', disposition: 'inline'
  end

  private

    def blob_qrcode
      if current_user&.referrer
        url_with_reference = url_for(
          action:       'show',
          id:      package_set.id,
          controller:   'guest/package_sets',
          host:         ENV['wechat_local_domain'],
          protocol:     'https',
          reference_id: current_user&.referrer&.reference_id,
          brand_id: brand.id
        )

        force_login_url = WechatUrlAdjuster.new(url_with_reference).adjusted_url
        qrcode_path = SmartQrcode.new(force_login_url).perform
        Flyer.new.process_cover_qrcode(brand.cover, qrcode_path).image.to_blob
      end
    end

    # for filtering (optional)
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end
end
