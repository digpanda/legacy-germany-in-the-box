module Helpers
  module Features
    module AddToCart

      module_function

      def add_to_cart!(product)
        visit guest_product_path(product)
        on_product_page?
        page.first('#js-add-to-cart').click
        expect(page).to have_content("产品添加成功") # success
      end

    end
  end
end
