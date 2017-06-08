feature "manage the cart", :js => true  do

  before(:each) {
    create_categories!
  }

  let(:product) { FactoryGirl.create(:product) }

  context "as a guest" do

    scenario "get redirected to the log-in module" do

      product_to_cart!(product)
      on_shop_page?
      page.first('#cart').trigger('click')
      on_chinese_login_page?

    end

  end

  context "as customer" do

    let(:customer) { FactoryGirl.create(:customer) }
    before(:each) { login!(customer) }

    scenario "go to the empty cart manager" do

      visit customer_cart_path
      on_cart_page? # empty cart manager page

    end

    context "with filled cart" do

      before(:each) { product_to_cart!(product) }

      scenario "cart manager shows checkout button" do

        # page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
        reload_page
        visit customer_cart_path
        on_cart_page?
        expect(page).to have_css "#checkout-button", text: "购买" # go checkout

      end

      scenario "change the quantity of one product in the cart manager" do

        # page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
        reload_page
        visit customer_cart_path
        2.times { page.first('.js-set-quantity-plus').trigger('click') } # raise quantity
        expect(page.first('span.cart__order-item-quantity-select-value')['innerHTML']).to eql("3")
        1.times { page.first('.js-set-quantity-minus').trigger('click') }
        expect(page.first('span.cart__order-item-quantity-select-value')['innerHTML']).to eql("2")

      end

    end


  end

end
