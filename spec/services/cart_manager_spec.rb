describe CartManager do

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:identity_solver) { IdentitySolver.new(request, current_user) }

  context "#.." do

    let(:order) { FactoryGirl.create(:order, status: :new) }

    let(:product) { FactoryGirl.create(:product) }
    let(:sku) { product.skus.first }

    it "should add an order item to the order" do
    end

  end

end
