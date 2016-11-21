feature "manage the cart", :js => true  do

  before(:each) {
    create_ui_categories!
  }

  let(:product) { FactoryGirl.create(:product) }

  context "as a guest" do

    scenario "get redirected to the log-in module" do

      visit guest_product_path(product)
      on_product_page?
      page.first('.product-quantity button').click
      on_shop_page?
      page.first('#total-products').click
      on_chinese_login_page?

    end

  end

  context "as customer" do

    let(:customer) { FactoryGirl.create(:customer) }
    before(:each) { login!(customer); puts "login" }

    scenario "go to the empty cart manager" do

      visit customer_cart_path
      expect(page).to have_current_path(customer_cart_path) # empty cart manager page

    end

    context "with filled cart" do

      before(:each) do

        # fill the cart
        visit guest_product_path(product)
        page.first('.product-quantity button').click

      end

      scenario "cart manager shows checkout button" do
        
        visit customer_cart_path
        expect(page).to have_current_path(customer_cart_path)
        expect(page).to have_css("btn-large +checkout-button") # have a checkout button on the cart

      end

      scenario "change the quantity of one product in the cart manager" do

        visit customer_cart_path
        2.times { page.first('.js-set-quantity-plus').click } # raise quantity
        page.first('.order-item-quantity').to have_content("3")
        1.times { page.first('.js-set-quantity-minus').click }
        page.first('.order-item-quantity').to have_content("2")

      end

    end


  end

end
