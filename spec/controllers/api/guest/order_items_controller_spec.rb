describe Api::Guest::OrderItemsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#update" do

    context "from guest customer" do

      let(:shop_with_orders) { FactoryGirl.create(:shop, :with_orders) }
      let!(:settings) { Settings.create! } # important for the controller

      it "set quantity to 0" do

        order_item = shop_with_orders.orders.first.order_items.first
        product = order_item.product

        params = {"quantity" => "0"}
        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)

        expect(response).to have_http_status(:bad_request)
        expect_json(success: false, code: 8)

      end

    end

  end

end
