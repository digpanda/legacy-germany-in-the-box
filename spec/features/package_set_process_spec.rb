feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) do
    login!(customer)
  end

  subject!(:package_set) { FactoryGirl.create(:package_set) }

  scenario "get a package set and go to checkout" do
    visit guest_package_sets_path
    # TODO : this task was not finished because we can't test it without the new design
    # those are acceptance test, there's no complex logic behind the package set
    # therefore we must wait until the new front-end is done.
  end

  scenario "get a package set, apply a coupon and go to checkout" do
  end

end
