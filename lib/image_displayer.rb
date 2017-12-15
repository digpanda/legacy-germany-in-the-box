require 'image_displayer/qiniu'

# manage the image display depending on the environment
# get the model and the image field and make the upload local or remote
# generate qiniu URLs and such
class ImageDisplayer
  FALLBACK_IMAGE = '/images/no_image_available.png'.freeze

  attr_reader :model, :image_field, :options, :version

  # the options possible are :fallback => true which return an image URL
  # in case no image is available whatsoever. this is mainly used
  # when the shopkeeper manipulate his images, it's very important.
  def initialize(model, image_field, options = {})
    @model = model
    @image_field = image_field.to_sym
    @options = options
  end

  def process(version)
    if Rails.env.development?
      local_url
    else
      remote_url(version)
    end
  end

  private

    def field_url
      if model.respond_to?(image_field)
        if model.send(image_field).present?
          model.send(image_field).url
        end
      end
    end

    def fallback_url
      FALLBACK_IMAGE
    end

    def local_url
      if valid_field_url?
        field_url
      elsif options[:fallback]
        fallback_url
      end
    end

    def remote_url(version)
      qiniu_url(version)
    end

    def valid_field_url?
      !field_url.nil? && !field_url.empty?
    end

    def qiniu_url(version)
      if valid_field_url?
        ImageDisplayer::Qiniu.new(field_url, version).url
      elsif options[:fallback]
        fallback_url
      end
    end
end
