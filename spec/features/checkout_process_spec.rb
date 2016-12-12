feature "checkout process", :js => true  do

  BORDERGURU_BASE_URL = "borderguru.com".freeze unless defined? BORDERGURU_BASE_URL
  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  context "checkout one normal product" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      add_to_cart!(product)
      page.first('#total-products').click # go to checkout
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

      scenario "can not go further without address created" do

        page.first('.\\+checkout-button').click # go to payment step
        expect(page).to have_css("#message-error") # error output

      end

      scenario "pay successfully and generate shipping label correctly" do

        add_address_from_lightbox!
        pay_and_get_label

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
        checkout_window = window_opened_by do
          page.first('button[value=creditcard]').click # pay with wirecard
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          find('#hpp-form-cancel').click
          find('#hpp-confirm-button-yes').click
          on_payment_method_page?
        end

      end

      scenario "fail to pay" do

        page.first('input[id^=delivery_destination_id').click # click on the first address
        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        checkout_window = window_opened_by do
          page.first('button[value=creditcard]').click # pay with wirecard
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_failed_creditcard!
          on_payment_method_page?
          expect(page).to have_css("#message-error")
        end

      end

      context "product got a discount" do

        let(:product) { FactoryGirl.create(:product, :with_20_percent_discount, shop_id: shop.id) }

        scenario "pay successfully and generate shipping label correctly" do

          # we go back to the cart
          page.first('#total-products').click
          expect(page).to have_content("-20%")
          # we check the 20% off is shown on the cart before all
          page.first('.\\+checkout-button').click # go to address step
          page.first('input[id^=delivery_destination_id').click # click on the first address
          pay_and_get_label

        end

      end

    end


  end

end

def pay_and_get_label

  page.first('.\\+checkout-button').click # go to payment step
  on_payment_method_page?
  checkout_window = window_opened_by do
    page.first('button[value=creditcard]').click # pay with wirecard
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
