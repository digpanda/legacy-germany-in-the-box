module Helpers
  module Features
    module ShowOnPage

      module_function

      def show_total_products(num)
        # show on the top of the page a specific number of products
        expect(page).to have_css "#total-products", text: "#{num}"
      end

      def on_chinese_login_page?
        expect(page).to have_css "h3", "用户登录"
      end

    end
  end
end
