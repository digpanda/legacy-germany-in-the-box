
describe ProductsController do

  render_views # jbuilder requirement

  context "guest to the website" do

    it "should get the popular products" do

      get :popular, :format => :json
      expect(response).to be_success

      #json = JSON.parse(response.body)

    end

    it "should get the detail of a specific product" do

      # TODO : We should generate a new product from FactoryGirl here
      #product = Product.first
      #get :show, id: product.id, :format => :json
      #expect(response).to be_success

    end
  end

  context "authenticated user to the website" do

    let(:user) { build :user }

    before { 
      allow(controller).to receive(:current_user) { user } 
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user) 
    }
    
    let(:current_user) { user }

    it "should like a product" do

      # TODO : We should generate a new product from FactoryGirl here
      #product = Product.first

      #patch :like, id: product.id, :format => :json # TODO : Uncomment when translation fix is done
      #expect(response).to be_success

    end

  end

end