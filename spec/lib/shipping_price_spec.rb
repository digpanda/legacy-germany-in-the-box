describe ShippingPrice do

  context "#price" do

    it "should return price for 3 * 5 small volume items" do # equivalent of 1 vol-kg
      # 3 * 5 items of length 5 / width 5 / height 8
      order = create(:order, :with_small_volume_items)
      expect(ShippingPrice.new(order).price).to eql(8.8)
    end

    it "should return price for 3 * 5 big volume items" do # equivalent of 16 vol-kg
      # 3 * 5 items of length 15 / width 20 / height 15
      order = create(:order, :with_big_volume_items)
      expect(ShippingPrice.new(order).price).to eql(45.6)
    end

    it "should return price for 1 * 5 small item" do # equivalent of 1 vol-kg
      # 1 * 5 items of length 5 / width 5 / height 8
      order = create(:order, :with_one_small_item)
      expect(ShippingPrice.new(order).price).to eql(8.8)
    end

    it "should return price for 2 * 5 big item" do # equivalent of 7 vol-kg
      # 2 * 5 items of length 15 / width 20 / height 15
      order = create(:order, :with_two_big_items)
      expect(ShippingPrice.new(order).price).to eql(22.6)
    end

  end

end
