describe Api::Guest::PackageSetsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#create" do

    context "from guest customer" do

      context "with one package set" do

        let(:package_set) { FactoryGirl.create(:package_set) }

        it "adds a package set to an order" do
          # style inspired from stackoverflow
          expect do
            post :create, {'package_set_id': package_set.id}
          end.to change(Order, :count).by(1)
        end

      end

      context "with multiple package sets from different shops" do

        let(:package_sets) { FactoryGirl.create_list(:package_set, 3) }

        it "adds package sets to multiple orders" do
          package_sets.each do |package_set|
            post :create, {'package_set_id': package_set.id}
            expect_json(success: true)
            # we need to hook this to make it look like it's different request
            # avoid instance variable memoization
            # NOTE : https://stackoverflow.com/questions/44259942/rspec-keeps-instance-variable-between-post-requests/44260046#44260046
            controller.instance_variable_set(:@order, nil)
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

  describe "#update" do

    context "from guest customer" do

      let(:order) { FactoryGirl.create(:order, :with_package_set) }
      let(:package_set) { order.package_sets.first }

      it "sets the quantity to 5" do
        # the cart manager session system can't be emulated easily
        # because we can't assign orders to guest so we have to stub it
        controller.instance_variable_set(:@order, order)
        patch :update, {'id': package_set.id, 'quantity': 5}
        expect_json(success: true)
        # using the model helper
        # NOTE : this should be improved
        expect(order.package_set_quantity(package_set)).to eq(5)
      end

    end
  end

end
