feature "checkout process", :js => true  do

  let(:customer) { FactoryGirl.create(:customer, :without_address) }

  before(:each) {
    login!(customer)
  }

  context "checkout one product" do

    let(:product) { FactoryGirl.create(:product) }

    before(:each) {
      add_to_cart!(product)
      page.first('#total-products').click # go to checkout
      page.first('.\\+checkout-button').click # go to address step
    }

    context "with no address" do

      scenario "can not go further" do
        # TODO
      end

    end

    context "with correct address" do

      scenario "pay successfully" do

        add_address_from_lightbox!
        binding.pry

      end

    end


  end

end
