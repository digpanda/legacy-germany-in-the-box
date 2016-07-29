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

  it "can access essential variables after creation" do

    wirecard = Wirecard::Customer.new(user, wirecard_hash_params)

    expect(wirecard.request_id).to be_kind_of(String)
    expect(wirecard.amount).to be_kind_of(Float)
    expect(wirecard.currency).to match("CNY")

  end

  it "has valid hosted payment data" do

    # as it is very hard to test this payment library, i chose to stay global 
    # and just see if it doesn't blow all the way up ; we should reinforce those tests at some point.
    wirecard = Wirecard::Customer.new(user, wirecard_hash_params)
    expect(wirecard.hosted_payment_datas).to be_kind_of(Hash)

  end

  it "has wrong arguments at initialization" do
    
    expect { Wirecard::Customer.new(user, {:merchant_id => 'test', :secret_key => 'test'}) }.to raise_error(Wirecard::Customer::Error)

  end

end