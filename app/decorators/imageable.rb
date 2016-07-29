require "abstract_method"

module Imageable
  extend ActiveSupport::Concern

  included do

    def image_url(img_field, version)
      if Rails.env.development?
        send(img_field).url
      else
        send(img_field).url + '&' + self.send("#{version.to_s}_params", img_field) if read_attribute(img_field)
      end
    end

    private

    abstract_method :thumb_params, :detail_params, :fullsize_params, :zoomin_params
  end

end