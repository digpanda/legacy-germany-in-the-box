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

    qrcode = Magick::Image.read("#{Rails.root}/public#{qrcode_path}").first
    qrcode = qrcode.resize_to_fit(415, 415)
    image.composite!(qrcode, 823, 212, Magick::OverCompositeOp)

    # TODO : check if it works with urls also
    cover = Magick::Image.read("#{Rails.root}/public#{cover}").first
    cover = cover.resize_to_fit(750, 750)
    image.composite!(cover, 40, 210, Magick::OverCompositeOp)

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

    append_image = Magick::Image.read(qrcode_path).first
    append_image = append_image.resize_to_fit(140, 140)

    image.composite!(append_image, 105, 540, Magick::OverCompositeOp)

    self
  end

  def process_qrcode(qrcode_path)
    @image = Magick::Image.read("#{Rails.root}/public/images/flyers/qrcode.jpg").first
    append_image = Magick::Image.read(qrcode_path).first
    append_image = append_image.resize_to_fit(339, 339)

    image.composite!(append_image, 130, 591, Magick::OverCompositeOp)

    image.format = 'jpeg'
    self
  end
end
