feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  context "with manual logistic partner" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      Setting.delete_all
      Setting.create!(:logistic_partner => :manual)
      add_to_cart!(product)
      page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
      page.first('#cart').click # go to checkout
      page.first('.\\+checkout-button').click # go to address step
    end

    scenario "can pay successfully" do

      page.first('input[id^=delivery_destination_id').click # click on the first address
      pay_and_check_manual_partner!

    end

  end

  context "with borderguru" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      Setting.delete_all
      Setting.create!(:logistic_partner => :borderguru)
      add_to_cart!(product)
      page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
      page.first('#cart').click # go to checkout
      page.first('.\\+checkout-button').click # go to address step
    end

    context "without essential informations (wechat like)" do

      let(:customer) { FactoryGirl.create(:customer, :from_wechat, :without_name, :without_address) }

      scenario "fill essential information and pay successfully" do

        on_missing_info_page?
        fill_in 'user[email]', :with => 'random-valid-email@email.com'
        fill_in 'user[lname]', :with => '前'
        fill_in 'user[fname]', :with => '单'
        page.first('.\\+checkout-button').click # go to address step
        on_order_address_page?

      end

      scenario "try checking out directly and is redirected to fulfil informations" do

        # short hook to check if we cannot access
        # the checkout without fulfilling those informations
        visit payment_method_customer_checkout_path
        on_missing_info_page?

      end

    end

    context "address built from scratch" do

      let(:customer) { FactoryGirl.create(:customer, :without_address) }

      scenario "pay successfully and generate shipping label correctly" do

        fill_in_address!
        pay_and_get_label!

      end

    end

    context "address already setup" do

      # we use the default `customer` which includes a valid address
      scenario "can not go further without address selected" do

        page.first('.\\+checkout-button').click # go to payment step
        expect(page).to have_css("#message-error") # error output

      end

      scenario "cancel payment" do

        page.first('input[id^=delivery_destination_id').click # click on the first address
        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        # checkout_window = window_opened_by do
          page.first('a[id=visa]').click # pay with wirecard
          # page.first('.\\+checkout-button').click
        # end

        # within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          find('#hpp-form-cancel').click
          find('#hpp-confirm-button-yes').click
          on_payment_method_page?
        # end

      end

      scenario "fail to pay" do

        page.first('input[id^=delivery_destination_id').click # click on the first address
        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        # checkout_window = window_opened_by do
          page.first('a[id=visa]').click # pay with wirecard
          # page.first('.\\+checkout-button').click
        # end

        # within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_failed_creditcard!
          on_payment_method_page?
          expect(page).to have_css("#message-error")
        # end

      end

      context "product got a discount" do

        let(:product) { FactoryGirl.create(:product, :with_20_percent_discount, shop_id: shop.id) }

        scenario "pay successfully and generate shipping label correctly" do

          # we go back to the cart
          page.first('#cart').click
          expect(page).to have_content("-20%")
          # we check the 20% off is shown on the cart before all
          page.first('.\\+checkout-button').click # go to address step
          page.first('input[id^=delivery_destination_id').click # click on the first address
          pay_and_get_label!

        end

      end

      context "apply a coupon" do

        scenario "pay successfully and generate shipping label correctly with coupon" do

          page.first('#cart').click
          aaa_coupon!
          page.first('.\\+checkout-button').click
          page.first('input[id^=delivery_destination_id').click
          pay_and_get_label!

        end

      end

    end

  end

end
