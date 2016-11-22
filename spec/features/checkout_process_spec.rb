feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer) }

  before(:each) {
    login!(customer)
  }

  context "checkout one product" do

    before(:each) {
      add_to_cart!(product)
      page.first('#total-products').click # go to checkout
    }

    let(:product) { FactoryGirl.create(:product) }

    context "with correct address" do

      scenario "pay successfully" do
      end

    end


  end

end
