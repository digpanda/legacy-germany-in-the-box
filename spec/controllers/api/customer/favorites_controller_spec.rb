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

        shop.products[0..4].each do |product|
          put :update, :id => product.id
        end


        put :update, :id => shop.products.first.id

        current_user.reload
        expect(current_user.favorites.count).to eq(5)

      end

      it "refuse to add a wrong favorite" do

        put :update, :id => "wrong-id"
        expect(response_json_body["success"]).to eq(false)
        expect(response_json_body["code"]).to eq(6)
        current_user.reload
        expect(current_user.favorites.count).to eq(0)

      end

    end

    context "customer with favorites" do

      let(:current_user) { FactoryGirl.create(:customer, :with_favorites) }
      before(:each) { login_customer current_user }
      let(:shop) { FactoryGirl.create(:shop) }

      it "adds a favorite" do

        num_favorites = current_user.favorites.count
        put :update, :id => shop.products.first.id
        expect(response_json_body["success"]).to eq(true)
        current_user.reload
        expect(current_user.favorites.count).to eq(num_favorites+1)

      end

    end

    context "unauthorized person" do

      let(:shop) { FactoryGirl.create(:shop) }

      it "adds a favorite" do
        put :update, :id => shop.products.first.id
        expect(response_json_body["success"]).to eq(false)
        expect(response_json_body["code"]).to eq(7)
      end

    end

  end

  describe "#destroy" do

  end

end