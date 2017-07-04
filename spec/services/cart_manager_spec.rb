describe CartManager do

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:identity_solver) { IdentitySolver.new(request, current_user) }

  context "#order" do

    it "creates a new order in the cart" do
    end
    
    it "recovers an order in the cart" do
    end

  end

  context "#store" do

    it "stores a new order within the cart" do
    end

  end

  context "#empty!" do

    it "empties the cart completely" do
    end

  end

  context "#refresh!" do

    it "refreshes the cart from cancelled and bought orders" do
    end

  end

  context "#products_number" do

    it "returns the products number with only casual products" do
    end

    it "returns the products number with casual products and package sets"

  end

  context "#in?" do

    it "confirms the order is in" do
    end

    it "does not confirm the order is in" do
    end

  end

  context "#out?" do

    it "confirms the order is out" do
    end

    it "does not confirm the order is out" do
    end

  end

end
