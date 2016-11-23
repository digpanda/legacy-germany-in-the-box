module Helpers
  module Features
    module Checkout

      def add_address_from_lightbox!
        page.first('.address-box').click # open address box
        fill_in 'address[fname]', :with => '薇'
        fill_in 'address[lname]', :with => '李'
        fill_in 'address[mobile]', :with => '13802049742'
        fill_in 'address[pid]', :with => '11000019790225207X'

        all('#address_province option')[rand(0..5)].select_option
        all('#address_city option')[1].select_option
        all('#address_district option')[1].select_option

        fill_in 'address[street]', :with => '华江里'
        fill_in 'address[zip]', :with => '300222'

        page.first('#address_primary').click
        page.first('input[type=submit]').click
      end

      # process to fill in wirecard creditcard outside of our site
      def apply_wirecard_creditcard!
        fill_in 'first_name', :with => 'Sha'
        fill_in 'last_name', :with => 'He'
        fill_in 'account_number', :with => '4012000300001003'
        fill_in 'card_security_code', :with => '003'
        binding.pry
        all('#expiration_month_list option')[0].select_option # 01
        all('#expiration_month_list option')[0].select_option # 01

        binding.pry
      end

    end
  end
end
