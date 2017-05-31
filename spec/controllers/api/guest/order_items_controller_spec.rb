describe Api::Guest::OrderItemsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#create" do

    context "from guest customer" do

      let(:shop) { FactoryGirl.create(:shop, :with_orders) }

      # chain creation depending on the test
      let(:order_item) { shop.orders.first.order_items.first }
      let(:product) { order_item.product }
      let(:sku) { order_item.sku_origin }
      let(:option_ids) { sku.option_ids.compact.join(',') }

      before :each do
        sku.update!({
          :quantity => 5,
          :unlimited => false,
          })
      end

      it "adds a product to an order" do
        post :create, {'product_id': product.id, 'sku_id': sku.id, 'quantity': 1}
        expect_json(success: true)
      end

      it "does not add a product if not enough stock" do
        post :create, {'product_id': product.id, 'sku_id': sku.id, 'quantity': 10}
        expect_json(success: false)
      end
    end
  end

  describe "#update" do

    context "from guest customer" do

      let(:shop) { FactoryGirl.create(:shop, :with_orders) }

      let(:order_item) { shop.orders.first.order_items.first }
      let(:product) { order_item.product }

      # we get the correct sku matching the order_item
      # we are careful to take the original sku and not the one in the order item
      # so we can basically manipulate quantities
      let(:sku) { order_item.sku_origin }

      before :each do
        sku.update!({
          :quantity => 5,
          :unlimited => false,
          })
      end

      it "cannot set quantity to 0" do
        params = {"quantity" => "0"}
        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)

        expect(response).to have_http_status(:bad_request)
        expect_json(success: false, code: 8)
      end

      it "set quantity to 5" do
        params = {"quantity" => "5"}
        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)

        expect(response).to have_http_status(:success)
        expect_json(success: true)
      end

      it "cannot set quantity to 500" do
        params = {"quantity" => "500"}

        patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)
        expect_json(success: false, code: 13)
      end

    end

  end

end
