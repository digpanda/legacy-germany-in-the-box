describe Wirecard::Customer do

  let(:user) { FactoryGirl.create(:customer, :with_orders) } # not current_user, we are testing a lib here
  let(:order) { user.orders.first }
  let(:shop) { orders.first.shop }
  let(:wirecard_hash_params) {

      {
        
        :merchant_id  => 'dfc3a296-3faf-4a1d-a075-f72f1b67dd2a',
        :secret_key   => '6cbfa34e-91a7-421a-8dde-069fc0f5e0b8',
        :order        => order,

      }

  }

  it "set a valid digital signature" do

    wirecard = Wirecard::Customer.new(user, wirecard_hash_params)
    # make a static user and check critical parameters from there

  end

  it "has valid hosted payment data" do

  end

  it "set wrong hosted payment data" do
  end

end