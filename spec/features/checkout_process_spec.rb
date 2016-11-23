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
        on_order_address_page? # go back to the current page
        # TODO : fix this so it doesn't blow up anymore

      end

    end

    context "with correct address" do

      before(:each) {
        add_address_from_lightbox!
      }

      scenario "pay successfully" do

        page.first('.\\+checkout-button').click # go to payment step
        on_payment_method_page?
        checkout_window = window_opened_by do
          page.first('button[value=creditcard]').click # pay with wirecard
        end

        within_window checkout_window do
          wait_for_page('#hpp-logo') # we are on wirecard hpp
          apply_wirecard_creditcard!
          expect(page).to have_content("下单成功") # means success in chinese
        end

      end

    end


  end

end
