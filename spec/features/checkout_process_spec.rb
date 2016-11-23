feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer, :without_address) }

  before(:each) {
    login!(customer)
  }

  context "checkout one product" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) {
      add_to_cart!(product)
      page.first('#total-products').click # go to checkout
      page.first('.\\+checkout-button').click # go to address step
    }

    context "with no address" do

      scenario "can not go further" do

        page.first('.\\+checkout-button').click # go to payment step
        expect(page).to have_css("#message-error") # error output

      end

    end

    context "with correct address" do

      before(:each) do
        add_address_from_lightbox!
      end

      scenario "pay successfully" do

        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        checkout_window = window_opened_by do
          page.first('button[value=creditcard]').click # pay with wirecard
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_success_creditcard!
          expect(page).to have_content("下单成功") # means success in chinese
        end

      end

      scenario "cancel payment" do

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

    end


  end

end
