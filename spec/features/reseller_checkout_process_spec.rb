# TODO : this should be split up into smaller tests than a whole login process
# but this is good enough for now and was fast to write.
feature 'reseller checkout process', js: true do

  let(:customer) { FactoryGirl.create(:customer, :with_referrer, :with_parent_referrer) }
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

  scenario 'pay successfully with reseller price' do
    expect(Order.first.price_origins).to eq([:reseller_price])
    pay_with_alipay!
    # we check essential things which should not be set
    expect(ReferrerProvision.count).to eq(0)
  end

end
