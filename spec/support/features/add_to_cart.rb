module Helpers
  module Features
    module AddToCart

      module_function

      def add_to_cart!(product)
        visit guest_product_path(product)
        page.first('button[type=submit]').click
      end

    end
  end
end
