describe OrderMaker do

  context "#add" do

    let(:order) { FactoryGirl.create(:order) }
    let(:sku) { FactoryGirl.create(:sku) }
    let(:product) { FactoryGirl.create(:product) }

    it "should add an order item to the order" do
      OrderMaker.new(order).add(sku, product, 1)
    end
  end
end
