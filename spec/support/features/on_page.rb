module Helpers
  module Features
    module OnPage
      XIPOST_BASE_URL = 'xipost.de'.freeze unless defined? XIPOST_BASE_URL

      module_function

      def on_identity_page?
        expect(page).to have_current_path(edit_customer_identity_path)
      end

      def on_shop_page?
        # contains a shop-page header content
        expect(page).to have_css '.shop-page-header__content'
      end

      def on_product_page?
        # contains a product-page description
        expect(page).to have_css '.product-page__description'
      end

      # def on_cart_page?
      #   expect(page).to have_css '#checkout-button'
      #   expect(page).to have_css '.total__end-price'
      # end

      def on_cart_page?
        expect(page).to have_current_path(customer_cart_path)
      end

      def on_chinese_login_page?
        expect(page).to have_css 'h3', text: '用户登录'
      end

      def on_payment_method_page?
        expect(page).to have_content('我的支付方式')
        expect(page).to have_current_path(payment_method_customer_checkout_path)
      end

      def on_order_address_page?
        expect(page).to have_css('form#new_address')
      end

      def on_missing_info_page?
        expect(page).to have_css 'h2', text: '请确认您的信息' # "we need more info"
      end
    end
  end
end
