# image processing
class Flyer < BaseService

  require "RMagick"
  include Magick

  attr_accessor :image

  def initialize
  end

  def process_steps(coupon)
    @image = Magick::ImageList.new("#{Rails.root}/public/images/flyers/steps.jpg")
    text = Magick::Draw.new

    image.annotate(text, 0,0,60,223, coupon.code) {
      text.gravity = Magick::SouthGravity
      text.pointsize = 40
      text.stroke = "#d23b1c"
      text.fill = "#d23b1c"
      text.font_weight = Magick::BoldWeight
    }

    image.format = "jpeg"
    self
  end

  def process_qrcode(qrcode_path)
    @image = Magick::Image.read("#{Rails.root}/public/images/flyers/qrcode.jpg").first
    append_image =  Magick::Image.read(qrcode_path).first
    append_image = append_image.resize_to_fit(170, 170)

    image.composite!(append_image, 100, 118, Magick::OverCompositeOp)

    image.format = "jpeg"
    self
  end

end
