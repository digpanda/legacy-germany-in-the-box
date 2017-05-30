describe Api::Guest::PackageSetsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#create" do

    context "from guest customer" do

      context "with one package set" do

        let(:package_set) { FactoryGirl.create(:package_set) }

        it "adds a package set to an order" do
          post :create, {'package_set_id': package_set.id}
          expect_json(success: true)
          # small check to know if we actually made
          # a real order successfully
          expect(Order.count).to eq(1)
        end

      end

      context "with multiple package sets from different shops" do

        let(:package_sets) { FactoryGirl.create_list(:package_set, 3) }

        it "adds package sets to multiple orders" do
          package_sets.each do |package_set|
            post :create, {'package_set_id': package_set.id}
            expect_json(success: true)
          end
          expect(Order.count).to eq(3)
        end

      end

      context "with multiple package sets from the same shop" do

        let(:shop) { FactoryGirl.create(:shop) }
        let(:package_sets) { FactoryGirl.create_list(:package_set, 3, shop: shop) }

        it "adds package sests to an order" do
          package_sets.each do |package_set|
            post :create, {'package_set_id': package_set.id}
            expect_json(success: true)
          end
          expect(Order.count).to eq(1)
          # were the paclage sets correctly put in it ?
          expect(Order.first.package_sets.count).to eq(3)
        end

      end

    end
  end

  # describe "#update" do
  #
  #   context "from guest customer" do
  #
  #     let(:shop) { FactoryGirl.create(:shop, :with_orders) }
  #
  #     let(:order_item) { shop.orders.first.order_items.first }
  #     let(:product) { order_item.product }
  #
  #     # we get the correct sku matching the order_item
  #     # we are careful to take the original sku and not the one in the order item
  #     # so we can basically manipulate quantities
  #     let(:sku) { order_item.sku_origin }
  #
  #     before :each do
  #       sku.update!({
  #         :quantity => 5,
  #         :unlimited => false,
  #         })
  #     end
  #
  #     it "cannot set quantity to 0" do
  #
  #       params = {"quantity" => "0"}
  #       patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)
  #
  #       expect(response).to have_http_status(:bad_request)
  #       expect_json(success: false, code: 8)
  #
  #     end
  #
  #     it "set quantity to 5" do
  #
  #       params = {"quantity" => "5"}
  #       patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)
  #
  #       expect(response).to have_http_status(:success)
  #       expect_json(success: true)
  #
  #     end
  #
  #     it "cannot set quantity to 500" do
  #
  #       params = {"quantity" => "500"}
  #       patch :update, {"id" => order_item.id, "product_id" => product.id}.merge(params)
  #
  #       expect_json(success: false, code: 13)
  #
  #     end
  #
  #   end
  #
  # end

end
