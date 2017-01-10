feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  scenario "get a package set and go to checkout" do
  end

  scenario "get a package set, apply a coupon and go to checkout" do
  end

end
