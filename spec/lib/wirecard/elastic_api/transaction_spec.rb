describe Wirecard::ElasticApi::Transaction do

  TEST_MERCHANT = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
  TEST_TRANSACTION = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"

  context "#response" do

    it 'should return a response hash' do

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do
        response = Wirecard::ElasticApi::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION).response
        assert_instance_of Hash, response
        expect(response[:payment][:"transaction-state"]).to eql("success")
      end

    end

    it 'should not find the transaction and raise an error' do

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do
        expect{Wirecard::ElasticApi::Transaction.new(TEST_MERCHANT, "fake-transaction").response}.to raise_error(Wirecard::ElasticApi::Error)
      end

    end

  end

  context "#status" do

    it 'should return the status' do

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do
        status = Wirecard::ElasticApi::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION).status
        expect(status).to eql(:success)
      end

    end

    it 'should raise a status error' do

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do
        transaction = Wirecard::ElasticApi::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION)
        allow(transaction).to receive(:response) { {} }
        expect{transaction.status}.to raise_error(Wirecard::ElasticApi::Error)

        transaction = Wirecard::ElasticApi::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION)
        allow(transaction).to receive(:response) { {:payment => {:"transaction-state" => "fake-status"}} }
        expect{transaction.status}.to raise_error(Wirecard::ElasticApi::Error)
      end

    end

  end

end
