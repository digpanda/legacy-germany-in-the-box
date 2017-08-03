describe ShippingPrice do

  context '#price' do

    # NOTE : for now there's only one shipping price
    # it should be improved throughout time
    # to test this library better
    it 'should return price for small volume sku' do
      order = create(:order, :with_small_volume_items)
      expect(ShippingPrice.new(order).price).to eql(8.0)
    end

    it 'should return price for big volume sku' do
      order = create(:order, :with_big_volume_items)
      expect(ShippingPrice.new(order).price).to eql(24.0)
    end

  end

end
