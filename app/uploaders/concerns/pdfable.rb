module Concerns
  module Pdfable
    extend ActiveSupport::Concern

    included do

      def extension_white_list
        %w(pdf)
      end

    end
  end
end
