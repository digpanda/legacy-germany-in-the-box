describe Api::Customer::FavoritesController, :type => :controller do

  render_views

  describe "#update" do

    context "customer without favorite" do

      let(:current_user) { FactoryGirl.create(:customer) }
      before(:each) { login_customer current_user }
      
      let(:shop) { FactoryGirl.create(:shop) }

      it "adds a favorite" do

        put :update, :id => shop.products.first.id
        expect(response_json_body["success"]).to eq(true)
        current_user.reload
        expect(current_user.favorites.count).to eq(1)

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

  end

end