describe ShippingPrice do

  let(:order) { create(:order, :with_small_volume_items) }
  context "#price" do

    it "should return price for 1 carton" do
      s = ShippingPrice.new(order)
      binding.pry
    end

  end

end
