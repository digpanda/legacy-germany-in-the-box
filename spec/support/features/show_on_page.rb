module Helpers
  module Features
    module ShowOnPage
      module_function

      def show_total_products(num)
        # show on the top of the page a specific number of products
        expect(page).to have_css '.js-total-products', text: "#{num}"
      end
    end
  end
end
