# TODO : this should be split up into smaller tests than a whole login process
# but this is good enough for now and was fast to write.
feature 'reseller checkout process', js: true do

  let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
  let(:product) { FactoryGirl.create(:product, shop_id: shop.id) }

  before(:each) do
    process_login(customer)
    logistic!(partner: :manual)
    product_to_cart!(product)
    reload_page
    page.first('#cart').click # go to checkout
    page.first('#checkout-button').click # go to address step
  end

  context 'as a default user' do

    let(:customer) { FactoryGirl.create(:customer, :with_referrer, :with_parent_referrer) }

    scenario 'pay successfully with default reseller price' do
      expect(Order.first.price_origins).to eq([:default_reseller_price])
      pay_with_alipay!
      # we check essential things which should not be set
      expect(ReferrerProvision.count).to eq(0)
    end

  end

  context 'as junior user' do

      let(:customer) { FactoryGirl.create(:customer, :with_referrer, :with_parent_referrer, group: :junior) }

    before(:each) do
      customer.group = :junior
      customer.save(validate: false)
    end

    scenario 'pay successfully with junior reseller price' do
      expect(Order.first.price_origins).to eq([:junior_reseller_price])
      pay_with_alipay!
    end

  end

end
