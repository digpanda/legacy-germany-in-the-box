require 'image_displayer/qiniu'

# manage the image display depending on the environment
# generate qiniu URLs and such
class ImageDisplayer

  attr_reader :model, :image_field, :version

  def initialize(model, image_field)
    @model = model
    @image_field = image_field.to_sym
  end

  def process(version)
    if Rails.env.development?
      field_url
    else
      remote_url(version)
    end
  end

  private

  def field_url
    model.send(image_field).url
  end

  def remote_url(version)
    qiniu_url(version) unless qiniu_url(version).empty?
  end

  def qiniu_url(version)
    ImageDisplayer::Qiniu.new(field_url, version).url unless field_url.nil?
  end

end
