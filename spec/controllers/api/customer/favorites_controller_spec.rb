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
=begin
      it "refuse to add a wrong favorite" do

        put :update, :id => "wrong-id"
        expect(response_json_body["success"]).to eq(false)
        current_user.reload
        expect(current_user.favorites.count).to eq(0)

      end
=end
    end

    context "customer with favorites" do
    end

    context "unauthorized person" do
    end

  end

end