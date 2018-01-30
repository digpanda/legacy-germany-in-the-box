class Guest::BrandsController < ApplicationController
  attr_reader :brand

  before_filter do
    restrict_to :customer
  end

  before_action :set_brand

  def promote_qrcode
    if blob_qrcode
      send_data blob_qrcode, stream: 'false', filename: 'qrcode.jpg', type: 'image/jpeg', disposition: 'inline'
    end
  end

  private

    def blob_qrcode
      @blob_qrcode ||= begin
        if current_user&.referrer
          url_with_reference = url_for(
            action:       'index',
            controller:   'guest/package_sets',
            host:         ENV['wechat_local_domain'],
            protocol:     'https',
            reference_id: current_user&.referrer&.reference_id,
            brand_id: brand.id
          )

          force_login_url = WechatUrlAdjuster.new(url_with_reference).adjusted_url
          smart_qrcode = SmartQrcode.new(force_login_url)
          qrcode_path = smart_qrcode.perform

          # if anything happens in the middle of the process
          # we will destroy the file so it doesn't block future scans
          begin
            return Flyer.new.process_cover_qrcode(brand.cover_url, qrcode_path).image.to_blob
          rescue Magick::ImageMagickError => exception
            smart_qrcode.destroy
          end
        end
      end
    end

    # for filtering (optional)
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end
end
