module Helpers
  module Features
    module Checkout

      BORDERGURU_BASE_URL = "borderguru.com".freeze unless defined? BORDERGURU_BASE_URL

      def aaa_coupon!
        FactoryGirl.create(:coupon, code: "AAA")
        fill_in 'coupon[code]', :with => "AAA"
        click_on '使用'
        expect(page).to have_content "此优惠券已被成功使用。"
      end

      def pay_and_check_manual_partner!

        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        checkout_window = window_opened_by do
          page.first('input[value=creditcard]').click # pay with wirecard
          page.first('.\\+checkout-button').click
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_success_creditcard!
          expect(page).to have_content("下单成功") # means success in chinese
          expect(page).to have_content("Tracking unavailable")
        end

      end

      def pay_and_get_label!

        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        checkout_window = window_opened_by do
          page.first('input[value=creditcard]').click # pay with wirecard
          page.first('.\\+checkout-button').click
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_success_creditcard!
          expect(page).to have_content("下单成功") # means success in chinese
          @borderguru_label_window = window_opened_by do
            click_link "打开" # click on "download your label" in chinese
            # expect(page).to have_no_css('#message-error')
          end
        end

        within_window @borderguru_label_window do
          expect(page.current_url).to have_content(BORDERGURU_BASE_URL) # we check we accessed borderguru
        end

        @borderguru_label_window = nil
      end

      def fill_in_address!

        # page.first('.address-box').click # <--- OLD SYSTEM // open address box
        fill_in 'address[fname]', :with => '薇'
        fill_in 'address[lname]', :with => '李'
        fill_in 'address[mobile]', :with => '13802049742'
        # fill_in 'address[pid]', :with => '11000019790225207X'

        loop until page.all(:css, '#address_province option')[1]
        page.all(:css, '#address_province option')[1].select_option
        loop until page.all(:css, '#address_city option')[1]
        page.all(:css, '#address_city option')[1].select_option
        loop until page.all(:css, '#address_district option')[1]
        page.all(:css, '#address_district option')[1].select_option

        fill_in 'address[street]', :with => '华江里'
        fill_in 'address[zip]', :with => '300222'

        page.first('#address_primary').click
        page.first('input[type=submit]').click
      end

      # process to fill in wirecard creditcard outside of our site
      def apply_wirecard_success_creditcard!
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => '4012000100000007'
        fill_in 'card_security_code', :with => '007'
        apply_wirecard_month_and_year!
        # expect(page).to have_css('#hpp-form-submit')
        find('#hpp-form-submit').click
      end

      # failing credit card (demo)
      def apply_wirecard_failed_creditcard!
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => '4200000000000059'
        fill_in 'card_security_code', :with => '059'
        apply_wirecard_month_and_year!
        expect(page).to have_css('#hpp-form-submit')
        # page.first('#hpp-form-submit').click
        find('#hpp-form-submit').click
      end

      def apply_wirecard_month_and_year!
        expect(page).to have_css("#expiration_month_list option[value='01']")
        find("#expiration_month_list option[value='01']").select_option
        expect(page).to have_css("#expiration_year_list option[value='2019']")
        find("#expiration_year_list option[value='2019']").select_option
      end

    end
  end
end
