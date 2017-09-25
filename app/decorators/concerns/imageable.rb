module Concerns
  module Imageable
    extend ActiveSupport::Concern

    included do

      def image_url(image_field, version, options = {})
        ImageDisplayer.new(self, image_field, options).process(version)
      end

    end
  end
end
