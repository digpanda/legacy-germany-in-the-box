describe Api::Guest::OrderItemsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#create" do

    context "from guest customer" do

      let(:shop_with_orders) { FactoryGirl.create(:shop, :with_orders) }
      let(:product) { FactoryGirl.create(:product) }
      subject(:sku) { product.skus.first }
      let!(:setting) { Setting.create! } # important for the controller
      

      it "adds a product to an order" do
        order_item = shop_with_orders.orders.first.order_items.first
        product = order_item.product
        option_ids = product.skus.first.option_ids.compact.join(',')
        sku_origin = product.skus.first
        sku_origin.quantity = 10
        sku_origin.unlimited = false
        sku_origin.save!
        post :create, {'product_id': product.id, 'quantity': 1, 'option_ids': option_ids}
        expect_json(success: true)
      end

      it "doesn't adds a product if out of stock" do
        order_item = shop_with_orders.orders.first.order_items.first
        product = order_item.product
        option_ids = product.skus.first.option_ids.compact.join(',')
        sku_origin = product.skus.first
        sku_origin.quantity = 5
        sku_origin.unlimited = false
        sku_origin.save!
        post :create, {'product_id': product.id, 'quantity': 10, 'option_ids': option_ids}
        expect_json(success: false)
      end
    end
  end

  describe "#update" do

    context "from guest customer" do

      let(:shop_with_orders) { FactoryGirl.create(:shop, :with_orders) }
      let!(:setting) { Setting.create! } # important for the controller
      

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
