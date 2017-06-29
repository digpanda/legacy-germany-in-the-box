describe OrderMaker do

  context "#sku" do

    let(:current_user) { FactoryGirl.create(:customer) }
    let(:request) { double('request', url: nil, session: {}, params: {}) }
    let(:identity_solver) { IdentitySolver.new(request, current_user) }

    let(:order) { FactoryGirl.create(:order, status: :new) }

    let(:product) { FactoryGirl.create(:product) }
    let(:sku) { product.skus.first }

    it "should add an order item to the order" do
      expect {
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(1)
      }.to change{order.order_items.count}.by(1)
    end

    it "should add an item multiple times to the order and change its quantity" do
      expect {
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(2)
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(3)
      }.to change{order.order_items.count}.by(1)

      expect(order.order_items.with_sku(sku).first.quantity).to eq(5)
    end

  end
end
