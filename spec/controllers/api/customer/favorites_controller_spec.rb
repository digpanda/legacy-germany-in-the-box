describe Api::Customer::FavoritesController, :type => :controller do

  render_views

  describe "#update" do

    context "customer without favorite" do

      before(:each) { login_customer }
      let(:shop) { FactoryGirl.create(:shop) }

      it "adds a favorite" do

        put :update, :id => shop.products.first.id
        binding.pry
        expect(response).to be_success

      end

      it "keep the same number of favorites when adding the same product" do
      end

      it "refuse to add a wrong favorite" do
      end

    end

    context "customer with favorites" do
    end

    context "unauthorized person" do
    end

=begin
  render_views # jbuilder requirement

  context "server to server without authentication" do

    let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }

    it "should throw a bad format error" do

      params = {"random" => true}
      post :create, request_wirecard_post(params)
      expect(response).to have_http_status(:bad_request)
      expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
      expect(response_json_body["code"]).to eq(1) # Error code from errors.yml

    end
=end

=begin
    def response_json_body
      JSON.parse(response.body)
    end

  end
=end
  end

end