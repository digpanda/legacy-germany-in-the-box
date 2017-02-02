module Helpers
  module Features
    module AddToCart

      module_function

      def add_to_cart!(product)
        visit guest_product_path(product)
        on_product_page?
        page.first('#js-add-to-cart').click
      end

    end
  end
end
