require 'image_displayer/qiniu'

# manage the image display depending on the environment
# get the model and the image field and make the upload local or remote
# generate qiniu URLs and such
class ImageDisplayer

  attr_reader :model, :image_field, :options, :version

  # the options possible are :fallback => true which return an image URL
  # in case no image is available whatsoever. this is mainly used
  # when the shopkeeper manipulate his images, it's very important.
  def initialize(model, image_field, options={})
    @model = model
    @image_field = image_field.to_sym
    @options = options
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
    if model.send(image_field).present?
      model.send(image_field).url
    elsif options[:fallback]
      fallback_url
    end
  end

  def fallback_url
    "/images/no_image_available.png"
  end

  def remote_url(version)
    qiniu_url(version)
  end

  def valid_field_url?
    (!field_url.nil? && !field_url.empty?) || field_url != fallback_url
  end

  def qiniu_url(version)
    if valid_field_url?
      ImageDisplayer::Qiniu.new(field_url, version).url
    end
  end

end
