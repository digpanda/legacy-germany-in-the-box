describe WirecardPaymentChecker  do

  context "#update_order_payment!" do

    let(:current_user) { FactoryGirl.create(:customer) }

    it "succeed and update the order payment" do

      order_payment = FactoryGirl.create(:order_payment, :with_scheduled)

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do

        valid_merchant = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
        valid_transaction = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"

        payment_checker = WirecardPaymentChecker.new({
          :merchant_account_id => valid_merchant,
          :transaction_id => valid_transaction,
          :request_id => SecureRandom.uuid,
          :order_payment => order_payment,
          })

        expect(payment_checker.update_order_payment!.success?).to eql(true)
        expect(order_payment.status).to eql(:success)

      end

    end

    it "succeed and update the order payment via order payments args only" do

      order_payment = FactoryGirl.create(:order_payment, :with_unverified_success)

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do

        expect(order_payment.status).to eql(:unverified)
        payment_checker = WirecardPaymentChecker.new({:order_payment => order_payment})
        expect(payment_checker.update_order_payment!.success?).to eql(true)
        expect(order_payment.status).to eql(:success)

      end

    end

    it "throw an invalid transaction" do

      order_payment = FactoryGirl.create(:order_payment, :with_scheduled)

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do

        valid_merchant = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
        invalid_transaction = "fake-transaction"

        payment_checker = WirecardPaymentChecker.new({
          :merchant_account_id => valid_merchant,
          :transaction_id => invalid_transaction,
          :request_id => SecureRandom.uuid,
          :order_payment => order_payment,
          })

        expect(payment_checker.update_order_payment!.success?).to eql(false)
        expect(order_payment.status).to eql(:unverified)

      end

    end

  end

end
