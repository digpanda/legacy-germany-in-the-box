describe Wirecard::Customer do

  let(:shop) { FactoryGirl.create(:shop) }
  
  it "is a hash of datas" do

    assert_instance_of Hash, Wirecard::Merchant.new(shop).apply_partnership_datas

  end

end