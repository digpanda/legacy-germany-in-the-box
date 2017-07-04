describe CartManager do

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:identity_solver) { IdentitySolver.new(request, current_user) }
  let(:cart_manager) { CartManager.new(request.session, current_user) }

  context "#order" do

    it "creates a new order in the cart according to a shop" do
      shop = FactoryGirl.create(:shop)
      order = cart_manager.order(shop: shop)

      expect(order).to be_an_instance_of(Order)
      expect(order.shop).to eq(shop)
    end

    it "recovers an order in the cart according to a shop" do
      # this will be changed later on
      shop = FactoryGirl.create(:shop)
      order = FactoryGirl.create(:order, shop: shop)
      cart_manager.store(order)
      recovered = cart_manager.order(shop: shop)
      expect(recovered).to be_an_instance_of(Order)
      expect(recovered.shop).to eq(shop)
    end

  end

  context "#store" do

    it "stores a new order within the cart" do
      order = FactoryGirl.create(:order)
      cart_manager.store(order)
      expect(cart_manager.orders.count).to eq(1)
    end

  end

  context "#orders" do

    it "get all the orders of the cart" do
      fill_cart_manager!
      expect(cart_manager.orders.count).to eq(3)
    end

  end

  context "#empty!" do

    it "empties the cart completely" do
      # this isn't really an empty, it's at session level and can be buggy as fuck
      fill_cart_manager!
      cart_manager.empty!
      expect(cart_manager.orders.count).to eq(0)
    end

  end

  context "#refresh!" do

    it "refreshes the cart from cancelled and bought orders" do
      orders = fill_cart_manager!
      orders.first.tap do |order|
        order.status = :paid
        order.save(validation: false)
      end
      cart_manager.refresh!
      expect(cart_manager.orders.count).to eq(2)
    end

  end

  context "#products_number" do

    it "returns the products number with only casual products" do
      fill_cart_manager!
      expect(cart_manager.products_number).to eq(45)
    end

    it "returns the products number with casual products and package sets" do
      orders = FactoryGirl.create_list(:order, 3, :with_package_set)
      orders.each do |order|
        cart_manager.store(order)
      end
      expect(cart_manager.products_number).to eq(3)
    end

  end

end

def fill_cart_manager!
  orders = FactoryGirl.create_list(:order, 3)
  orders.each do |order|
    cart_manager.store(order)
  end
  orders
end
