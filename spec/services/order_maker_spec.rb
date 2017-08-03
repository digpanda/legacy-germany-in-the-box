describe OrderMaker do

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:identity_solver) { IdentitySolver.new(request, current_user) }

  context '#sku' do

    let(:order) { FactoryGirl.create(:order, status: :new) }

    let(:product) { FactoryGirl.create(:product) }
    let(:sku) { product.skus.first }

    it 'should add an order item to the order' do
      expect {
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(1)
      }.to change{order.order_items.count}.by(1)
    end

    it 'should add an item multiple times to the order and change its quantity' do
      expect {
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(2)
        OrderMaker.new(identity_solver, order).sku(sku).refresh!(3)
      }.to change{order.order_items.count}.by(1)

      expect(order.order_items.with_sku(sku).first.quantity).to eq(5)
    end

  end

  context '#package_set' do

    let(:order) { FactoryGirl.create(:order, status: :new) }
    let(:package_set) { FactoryGirl.create(:package_set) }

    it 'should add a package set to the order' do
      expect {
        OrderMaker.new(identity_solver, order).package_set(package_set).refresh!(1)
      }.to change{order.package_set_quantity(package_set)}.by(1)
    end

    it 'should add an item multiple times to the order and change its quantity' do
      expect {
        OrderMaker.new(identity_solver, order).package_set(package_set).refresh!(2)
        OrderMaker.new(identity_solver, order).package_set(package_set).refresh!(3, increment: true)
      }.to change{order.package_set_quantity(package_set)}.by(5)
    end

  end

end
