module Imageable
  extend ActiveSupport::Concern

  included do

    def image_url(image_field, version)
      if Rails.env.development?
        send(image_field).url
      else
        send(image_field).url + '&' + self.send("#{version}_params", image_field) if read_attribute(image_field)
      end
    end

    private

    def thumb_params(image_field)
      Rails.configuration.product_image_thumbnail
    end

    def detail_params(image_field)
      Rails.configuration.product_image_detailview
    end
    
    def fullsize_params(image_field)
      Rails.configuration.product_image_fullsize
    end

    def zoomin_params(image_field)
      Rails.configuration.product_image_zoomin
    end

  end

end