require 'uri'

# image processing
class Flyer < BaseService
  require 'RMagick'
  include Magick

  attr_reader :image

  def initialize
  end

  # here we want to integrate the image
  # of the package set and the qrcode
  def process_cover_qrcode(cover, qrcode_path)
    @image = Magick::ImageList.new("#{Rails.root}/public/images/flyers/qrcode-with-image.jpg")

    insert_image(
      full_path: qrcode_path,
      width: 415, height: 415,
      longitude: 823, latitude: 212
    )

    if "#{cover}".present?
      insert_image(
        full_path: "#{cover}",
        width: 750, height: 750,
        longitude: 40, latitude: 50
      )
    end

    image.format = 'jpeg'
    self
  end

  def process_steps(coupon, qrcode_path)
    @image = Magick::ImageList.new("#{Rails.root}/public/images/flyers/steps.jpg")
    text = Magick::Draw.new

    image.annotate(text, 0, 0, 23, 280, coupon.code) {
      text.gravity = Magick::SouthGravity
      text.pointsize = 20
      text.stroke = '#d23b1c'
      text.fill = '#d23b1c'
      text.font_weight = Magick::BoldWeight
    }

    insert_image(
      full_path: qrcode_path,
      width: 140, height: 140,
      longitude: 105, latitude: 540
    )

    image.format = 'jpeg'
    self
  end

  def process_qrcode(qrcode_path)
    @image = Magick::Image.read("#{Rails.root}/public/images/flyers/qrcode.jpg").first

    insert_image(
      full_path: qrcode_path,
      width: 339, height: 339,
      longitude: 130, latitude: 591
    )

    image.format = 'jpeg'
    self
  end

  private

    def insert_image(full_path:, width:, height:, longitude:, latitude:)
      if url?(full_path)
        final_path = full_path
      else
        # #{Rails.root}/public
        final_path = "#{full_path}"
      end
      append_image = Magick::Image.read(final_path).first
      append_image = append_image.resize_to_fit(width, height)
      image.composite!(append_image, longitude, latitude, Magick::OverCompositeOp)
    end

    def url?(string)
      string.index('http') == 0
    end
end
