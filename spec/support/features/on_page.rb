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

      def on_log_in_page?
        visit new_user_session_path
        fill_in 'user[email]', :with => admin.email
        fill_in 'user[password]', :with => '12345678'
        click_button 'sign_in'
      end

    end
  end
end
