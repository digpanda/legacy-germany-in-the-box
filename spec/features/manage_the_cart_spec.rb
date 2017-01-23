feature "manage the cart", :js => true  do

  before(:each) {
    create_categories!
  }

  let(:product) { FactoryGirl.create(:product) }

  context "as a guest" do

    scenario "get redirected to the log-in module" do

      visit guest_product_path(product)
      on_product_page?
      page.first('.product-quantity button').click
      on_shop_page?
      page.first('#cart').click
      on_chinese_login_page?

    end

  end

  context "as customer" do

    let(:customer) { FactoryGirl.create(:customer) }
    before(:each) { login!(customer) }

    scenario "go to the empty cart manager" do

      visit customer_cart_path
      expect(page).to have_current_path(customer_cart_path) # empty cart manager page

    end

    context "with filled cart" do

      before(:each) { add_to_cart!(product) }

      scenario "cart manager shows checkout button" do

        visit customer_cart_path
        expect(page).to have_current_path(customer_cart_path)
        expect(page).to have_css ".\\+checkout-button", text: "确定收货地址" # go checkout

      end

      scenario "change the quantity of one product in the cart manager" do

        visit customer_cart_path
        2.times { page.first('.js-set-quantity-plus').click } # raise quantity
        expect(page.first('input[id^=order-item-quantity]').value).to eql("3")
        1.times { page.first('.js-set-quantity-minus').click }
        expect(page.first('input[id^=order-item-quantity]').value).to eql("2")

      end

    end


  end

end
