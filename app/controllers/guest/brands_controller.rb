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
      url_with_reference = guest_package_sets_path(brand_id: brand.id, reference_id: current_user&.referrer&.reference_id)
      qrcode_path = SmartQrcode.new(url_with_reference).perform
      Flyer.new.process_cover_qrcode(brand.cover, qrcode_path).image.to_blob
    end

    # for filtering (optional)
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end
end
