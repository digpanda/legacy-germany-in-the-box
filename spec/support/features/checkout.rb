module Helpers
  module Features
    module Checkout

      BORDERGURU_BASE_URL = "borderguru.com".freeze unless defined? BORDERGURU_BASE_URL
      WIRECARD_CREDIT_CARD = {
                                success: {
                                  account_number: '4012000100000007',
                                  card_security_code: '007'
                                },
                                fail: {
                                  account_number: '4200000000000059',
                                  card_security_code: '059'
                                }
                              }.freeze unless defined? WIRECARD_CREDIT_CARD

      # fill the complete chinese address
      def fill_in_checkout_address!
        fill_in 'address[fname]', :with => '薇'
        fill_in 'address[lname]', :with => '李'
        fill_in 'address[mobile]', :with => '13802049742'
        fill_in 'address[pid]', :with => '11000019790225207X'

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

      # fill in new checkout addresses even if one exists
      def fill_in_with_multiple_addresses!
        page.first('#button-new-address').click
        fill_in_checkout_address!
        page.first('input[id^=delivery_destination_id').click
      end

      def cancel_wirecard_visa_payment!
        page.first('a[id=visa]').click # pay with wirecard
        wait_for_page('#hpp-logo') # we are on wirecard hpp
        find('#hpp-form-cancel').click
        wait_for_page('#hpp-confirm-button-yes') # we are on wirecard hpp
        find('#hpp-confirm-button-yes').click
      end

      def pay_with_alipay!(mode: :success)
        page.first('.\\+checkout-button').click
        on_payment_method_page?
        page.first('a[id=alipay]').click
        wait_for_page('.alipay-logo')
      end

      def pay_with_wechatpay!(mode: :success)
        page.first('.\\+checkout-button').click
        on_payment_method_page?
        page.first('a[id=wechatpay]').click
        # we are just redirected without crashing
        # this is a pretty weak test
        # we compensate by testing the callbacks elsewhere
        wait_for_page('.germany-in-the-box')
      end

      # NOTE : this is not working properly anymore
      # enter all the payment information and pay
      def pay_with_wirecard_visa!(mode: :success)
        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        page.first('a[id=visa]').click # pay with wirecard
        wait_for_page('#hpp-logo') # we are on wirecard hpp
        apply_wirecard_creditcard!(mode: mode)
        if mode == :success
          expect(page).to have_content("下单成功") # means success in chinese
        else
          on_payment_method_page?
          expect(page).to have_css("#message-error")
        end
      end


      # access the manual logistic tracking
      def manual_partner_confirmed?
        expect(page).to have_content("追单")
      end

      # enter all the payment information and pay
      # access the borderguru tracking
      def borderguru_confirmed?
        borderguru_label_window = window_opened_by do
          click_link "追单" # click on "download your label" in chinese
        end

        within_window borderguru_label_window do
          expect(page.current_url).to have_content(BORDERGURU_BASE_URL) # we check we accessed borderguru
        end
      end

      # process to fill in wirecard creditcard outside of our site
      # can be :success, :fail to force different results
      def apply_wirecard_creditcard!(mode: :success)
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => WIRECARD_CREDIT_CARD[mode][:account_number]
        fill_in 'card_security_code', :with => WIRECARD_CREDIT_CARD[mode][:card_security_code]

        expect(page).to have_css("#expiration_month_list option[value='01']")
        find("#expiration_month_list option[value='01']").select_option
        expect(page).to have_css("#expiration_year_list option[value='2019']")
        find("#expiration_year_list option[value='2019']").select_option

        find('#hpp-form-submit').click
      end

    end
  end
end
