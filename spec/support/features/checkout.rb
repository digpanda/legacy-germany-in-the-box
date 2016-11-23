module Helpers
  module Features
    module Checkout

      def add_address_from_lightbox!
        page.first('.address-box').click # open address box
        fill_in 'address[fname]', :with => '薇'
        fill_in 'address[lname]', :with => '李'
        fill_in 'address[mobile]', :with => '13802049742'
        fill_in 'address[pid]', :with => '11000019790225207X'

        all('#address_province option')[2].select_option
        all('#address_city option')[1].select_option
        all('#address_district option')[1].select_option

        fill_in 'address[street]', :with => '华江里'
        fill_in 'address[zip]', :with => '300222'

        page.first('#address_primary').click
        page.first('input[type=submit]').click
      end

      # process to fill in wirecard creditcard outside of our site
      def apply_wirecard_success_creditcard!
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => '4012000300001003'
        fill_in 'card_security_code', :with => '003'
        find("#expiration_month_list").find("option[value='01']").click
        find("#expiration_year_list").find("option[value='2019']").click
        page.first('#hpp-form-submit').click
      end

      # failing credit card (demo)
      def apply_wirecard_failed_creditcard!
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => '4200000000000059'
        fill_in 'card_security_code', :with => '059'
        find("#expiration_month_list").find("option[value='01']").click
        find("#expiration_year_list").find("option[value='2019']").click
        page.first('#hpp-form-submit').click
      end

    end
  end
end
