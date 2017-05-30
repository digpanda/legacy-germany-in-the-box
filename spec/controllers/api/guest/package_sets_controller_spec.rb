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

end
