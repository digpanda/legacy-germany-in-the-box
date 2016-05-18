require "abstract_method"

module Imageable
  extend ActiveSupport::Concern

  included do

    def image_url(img_field, version)
      if Rails.env.local?
        read_attribute(img_field) ? send(img_field).url(version) : send(img_field).default_url
      else
        send(img_field).url + '&' + self.send("#{version.to_s}_params", img_field) if read_attribute(img_field)
      end
    end

    private

    abstract_method :thumb_params, :detail_params
  end

end