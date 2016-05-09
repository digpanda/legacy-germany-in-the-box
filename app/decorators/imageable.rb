require "abstract_method"

module Imageable
  extend ActiveSupport::Concern

  included do

    def image_url(img_field, version)
      if ENV['RAILS_ENV'] != 'local'
        send(img_field).url + '&' + self.send("#{version.to_s}_params") if read_attribute(img_field)
      else
        mas.send(img_field).url(version) if read_attribute(img_field)
      end
    end

    private

    abstract_method :thumb_params, :detail_params
  end

end