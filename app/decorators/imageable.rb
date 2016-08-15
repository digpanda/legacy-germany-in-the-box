module Imageable
  extend ActiveSupport::Concern

  included do

    def image_url(image_field, version)
      ImageDisplayer.new(self, image_field).process(version)
    end

  end

end
