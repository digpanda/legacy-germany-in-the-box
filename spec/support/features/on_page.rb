module Helpers
  module Features
    module OnPage

      module_function

      def on_shop_page?
        # contains a shop-page header content
        expect(page).to have_css '.shop-page-header__content'
      end

      def on_product_page?
        # contains a product-page description
        expect(page).to have_css '.product-page__description'
      end

      def on_chinese_login_page?
        expect(page).to have_css "h3", text: "用户登录"
      end

    end
  end
end
