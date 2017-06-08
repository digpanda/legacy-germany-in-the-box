feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  context "with xipost logistic partner" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      logistic!(partner: :xipost)
      product_to_cart!(product)
      reload_page # the AJAX call could make problem otherwise
      page.first('#cart').click # go to checkout
      page.first('#checkout-button').click # go to address step
    end

    scenario "pays successfully with wirecard visa" do
      pay_with_wirecard_visa!
      manual_partner_confirmed?
    end

    scenario "pays successfully with alipay" do
      pay_with_alipay!
      manual_partner_confirmed?
    end

    scenario "pays successfully with wechatpay" do
      pay_with_wechatpay!
      manual_partner_confirmed?
    end

  end

  context "with borderguru" do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      logistic!(partner: :borderguru)
      product_to_cart!(product)
      reload_page
      page.first('#cart').click # go to checkout
      page.first('#checkout-button').click # go to address step
    end

    context "without essential informations (wechat like)" do

      let(:customer) { FactoryGirl.create(:customer, :from_wechat, :without_name, :without_address) }

      scenario "fill essential information and pay successfully" do
        on_missing_info_page?
        fill_in 'user[email]', :with => 'random-valid-email@email.com'
        fill_in 'user[lname]', :with => '前'
        fill_in 'user[fname]', :with => '单'
        page.first('#checkout-button').click # go to address step
        on_order_address_page?
      end

    end

    context "address built from scratch" do

      let(:customer) { FactoryGirl.create(:customer, :without_address) }

      scenario "pay successfully and generate shipping label correctly" do
        fill_in_checkout_address!
        pay_with_wirecard_visa!
        borderguru_confirmed?
      end

    end

    context "address already setup" do

      scenario "fail to pay" do
        page.first('input[id^=delivery_destination_id]').click # click on the first address
        pay_with_wirecard_visa!(mode: :fail)
      end

      # context "product got a discount" do
      #
      #   let(:product) { FactoryGirl.create(:product, :with_20_percent_discount, shop_id: shop.id) }
      #
      #   scenario "pay successfully and generate shipping label correctly" do
      #     # we go back to the cart
      #     page.first('#cart').click
      #     # we check the 20% off is shown on the cart before all
      #     expect(page).to have_content("-20%")
      #     page.first('#checkout-button').click # go to address step
      #     page.first('input[id^=delivery_destination_id]').click # click on the first address
      #     pay_with_wirecard_visa!
      #     borderguru_confirmed?
      #   end
      #
      # end

      context "apply a coupon" do

        scenario "pay successfully and generate shipping label correctly with coupon" do
          page.first('#cart').click
          make_and_apply_coupon!
          page.first('#checkout-button').click
          page.first('input[id^=delivery_destination_id]').click
          pay_with_wirecard_visa!
          borderguru_confirmed?
        end

      end

    end

  end

end
