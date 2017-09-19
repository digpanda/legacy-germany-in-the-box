feature 'package set process', js: true, vcr: :skip do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  # NOTE : for now we don't have any protection regarding the order limit
  # for package sets
  subject!(:package_set) { FactoryGirl.create(:package_set, :with_500_euro_total) }

  scenario 'get a package set and go to checkout' do
    package_to_cart!
    go_to_cart!
    page.first('#checkout-button').trigger('click')
    fill_in_with_multiple_addresses!
    pay_with_alipay!
  end

  scenario 'get a package set, apply a coupon and go to checkout' do
    package_to_cart!
    go_to_cart!
    make_and_apply_coupon!
    page.first('#checkout-button').trigger('click')
    fill_in_with_multiple_addresses!
    pay_with_alipay!
  end

end
