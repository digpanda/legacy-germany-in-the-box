module Helpers
  module Features
    module Login

      module_function

      def add_to_cart!(product)
        visit guest_product_path(product)
        page.first('.product-quantity button').click
      end

    end
  end
end
