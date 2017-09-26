module Concerns
  module Imageable
    extend ActiveSupport::Concern

    included do

      attr_reader :width, :height
      before :capture_size

      def capture_size(file)
        if version_name.blank? # Only do this once, to the original version
          if file.path.nil? # file sometimes is in memory
            img = ::MiniMagick::Image::read(file.file)
            @width = img[:width]
            @height = img[:height]
          else
            @width, @height = `identify -format "%wx %h" #{file.path}`.split(/x/).map { |dim| dim.to_i }
          end
        end
      end

      def extension_white_list
        %w(jpg jpeg png)
      end

      version :thumb do
        process resize_to_limit: [250, 250]
      end

    end
  end
end
