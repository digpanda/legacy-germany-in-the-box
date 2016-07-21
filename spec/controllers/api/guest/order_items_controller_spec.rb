describe Api::Guest::OrderItemsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#update" do

    context "from guest customer" do

      let(:shop_with_orders) { FactoryGirl.create(:shop, :with_orders) }
      let(:settings) { Settings.create! } # important for the controller
      before { settings }

      it "set quantity to 0" do

        order_item = shop_with_orders.orders.first.order_items.first
        product = order_item.product

        params = {"quantity" => "0"}
        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)

        expect(response).to have_http_status(:bad_request)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(8) # Error code from errors.yml

      end

=begin
      it "set quantity to 2" do

        order_item = shop_with_orders.orders.first.order_items.first
        product = order_item.product

        params = {"quantity" => "2"}
        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)

        expect(response).to have_http_status(:ok)
        expect(response_json_body["success"]).to eq(true) # Check if the server replied properly

      end
=end
    end

  end

end