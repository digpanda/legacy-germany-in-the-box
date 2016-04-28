describe ProductsController do

  context "guest to the website" do

    it "should get the popular products" do

      get :popular, :format => :json
      expect(response).to be_success

    end

    it "should get the detail of a specific product" do

      # TODO : We should generate a new product from FactoryGirl here
      product = Product.first
      get :show, id: product.id, :format => :json
      expect(response).to be_success

    end

  end

  context "authenticated user to the website" do

    let(:user) { build :user }
    before { allow(controller).to receive(:current_user) { user } }
    let(:current_user) { user }

    it "should like a product" do

      # TODO : We should generate a new product from FactoryGirl here
      product = Product.first

      header 'X-User-Token', '3_XoKdZ_-Deak-zskYzz'
      header 'X-User-Email', 'test@test.com'
      patch :like, id: product.id, :format => :json
      expect(response).to be_success

    end

  end

end