describe ShippingPrice do

  context "#price" do

    it "should return price for small volume sku" do # equivalent of 1 vol-kg
      # 3 * 5 items of length 5 / width 5 / height 8
      sku = create(:product, :with_small_volume).skus.first
      expect(ShippingPrice.new(sku).price).to eql(35.0)
    end

    it "should return price for  big volume sku" do # equivalent of 16 vol-kg
      # 3 * 5 items of length 15 / width 20 / height 15
      sku = create(:product, :with_big_volume).skus.first
      expect(ShippingPrice.new(sku).price).to eql(35.0)
    end

  end

end
