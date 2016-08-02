describe ShippingPrice do

  context "#price" do

    it "should return price for 1 carton" do
      order = create(:order, :with_small_volume_items)
      expect(ShippingPrice.new(order).price).to eql(8.8) # current first kilo price
    end

    it "should return price for 2 cartons" do
      order = create(:order, :with_big_volume_items)
      expect(ShippingPrice.new(order).price).to eql(33.0) # current first kilo price
    end

  end

end
