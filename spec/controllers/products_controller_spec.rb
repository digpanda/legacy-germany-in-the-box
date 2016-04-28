describe ProductsController do

  context "guest to the website" do

    it "should get the popular products" do

      get :popular, :format => :json
      expect(response).to be_success

    end

    it "should get the detail of a specific product" do

      get :popular, :format => :json
      expect(response).to be_success

    end

  end

end