feature 'checkout process', js: true do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    process_login(customer)
  end

  context 'with mkpost logistic partner' do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      logistic!(partner: :mkpost)
      product_to_cart!(product)
      reload_page # the AJAX call could make problem otherwise
      page.first('#cart').click # go to checkout
      page.first('#checkout-button').click # go to address step
    end

    scenario 'pays successfully with alipay' do
      pay_with_alipay!
      manual_partner_confirmed?
    end

    # NOTE : for now we could not test this part successfully because the test environment does not work anymore
    # we have to find a work around to check it out.
    scenario 'pays successfully with wechatpay' do
      #pay_with_wechatpay!
      #manual_partner_confirmed?
    end

  end

  context 'with manual logistic' do

    let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
    let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

    before(:each) do
      logistic!(partner: :manual)
      product_to_cart!(product)
      reload_page
      page.first('#cart').click # go to checkout
      page.first('#checkout-button').click # go to address step
    end

    context 'without essential informations (wechat like)' do

      let(:customer) { FactoryGirl.create(:customer, :from_wechat, :without_name, :without_address) }

      scenario 'fill essential information and pay successfully' do
        on_missing_info_page?
        fill_in 'user[email]', with: 'random-valid-email@email.com'
        fill_in 'user[lname]', with: '前'
        fill_in 'user[fname]', with: '单'

        page.first('#checkout-button').click # go to address step
        page.first('#button-new-address').click # open new address form
        expect(page).to have_css('form#new_address')
      end

    end

    context 'address built from scratch' do

      let(:customer) { FactoryGirl.create(:customer, :without_address) }

      scenario 'pay successfully and generate shipping label correctly' do
        fill_in_checkout_address!
        pay_with_alipay!
      end

    end

    context 'address already setup' do

      scenario 'fail to pay' do
        pay_with_alipay!(mode: :fail)
      end

      context 'apply a coupon' do

        scenario 'pay successfully and generate shipping label correctly with coupon' do
          page.first('#cart').click
          make_and_apply_coupon!
          page.first('#checkout-button').click
          pay_with_alipay!
        end

      end

    end

  end

end
