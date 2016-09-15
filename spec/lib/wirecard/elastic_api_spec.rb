describe Wirecard::Hpp do

  before(:each) { VCR.turn_on! }
  after(:each) { VCR.turn_off! }
  
  it "can access essential variables after creation" do

    valid_merchant = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
    valid_transaction = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"

    VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do

      wirecard = Wirecard::ElasticApi.transaction(valid_merchant, valid_transaction)
      expect(wirecard.response.transaction_state).to eql(:success)

    end

  end

end
