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

end