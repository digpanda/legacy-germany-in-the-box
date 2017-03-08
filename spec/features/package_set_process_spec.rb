feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  # NOTE : for now we don't have any protection regarding the order limit
  # for package sets
  subject!(:package_set) { FactoryGirl.create(:package_set, :with_500_euro_total) }

  scenario "get a package set and go to checkout" do
    add_package!
    page.first('#cart').click
    page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
    page.first('.\\+checkout-button').click
    fill_in_with_multiple_addresses!
    pay_and_get_label!
  end

  scenario "get a package set, apply a coupon and go to checkout" do
    add_package!
    page.first('#cart').click
    aaa_coupon!
    page.driver.browser.navigate.refresh # the AJAX call could make problem otherwise
    page.first('.\\+checkout-button').click
    fill_in_with_multiple_addresses!
    pay_and_get_label!
  end

end

def add_package!
  visit guest_package_sets_path
  click_on "查看更多信息"
  expect(page).to have_content("¥ 3800.00")
  click_on "加入购物车"
end

def fill_in_with_multiple_addresses!
  page.first('#button-new-address').click
  fill_in_address!
  page.first('input[id^=delivery_destination_id').click
end
