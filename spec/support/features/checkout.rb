module Helpers
  module Checkout

    def add_address_from_lightbox!
      page.first('.address-box').click # open address box
      fill_in 'address[fname]', :with => '薇'
      fill_in 'address[lname]', :with => '李'
      fill_in 'address[mobile]', :with => '13802049742'
      fill_in 'address[pid]', :with => '11000019790225207X'

      all('#address_province option')[rand(0..10)].select_option
      all('#address_city option')[rand(0..5)].select_option
      all('#address_district option')[rand(0..5)].select_option

      fill_in 'address[street]', :with => '华江里'
      fill_in 'address[zip]', :with => '邮编'

      page.first('address_primary').click
      page.first('input[type=submit]').click
    end
    
  end
end
