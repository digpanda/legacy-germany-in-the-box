describe SmartExchange::Process do

  before(:each) do

    allow_any_instance_of(SmartExchange::Base).to receive(:messenger).and_return(
      # fake class to stub messenger
      Class.new do
        def text!(arg)
          true
        end
      end.new
    )

  end

  context '#perform' do

    let(:customer) { FactoryGirl.create(:customer, :from_wechat) }
    let(:introduced) { FactoryGirl.create_list(:customer, 10) }

    context 'simple exchanges' do

      it 'sends a ping' do
        perform = described_class.new(customer, 'ping').perform
        expect(perform).to eq(true)
      end

    end

    # we actually test the offers area with email typing
    # which is complex enough to fully crash the global exchange system
    # if buggy.
    context 'recursive exchanges' do

      it 'goes through the email challenge successfully' do

        described_class.new(customer, '优惠券').perform
        described_class.new(customer, '1').perform

        perform = described_class.new(customer, 'wrong-email').perform
        # it didn not achieve but it does send true, because the iteration was successfully achieved
        # it won't erase the breakpoint also
        expect(perform).to eq(true)
        # because the update we attempted we need to do that
        customer.reload
        expect(customer.email).not_to eq('wrong-email')

        # now we try again, it should pass because the memory is still on place
        perform = described_class.new(customer, 'valid-email@gmail.com').perform
        expect(perform).to eq(true)

        # because the update we attempted we need to make sure it's stored
        # NOTE : we cannot check that anymore since the email won't be "official" changed
        # until the user click on the matching link.
        # customer.reload
        # expect(customer.email).to eq('valid-email@gmail.com')

        # NOTE : we can't go further because it triggers emailing and confirmations from devise
        # if so far it works, then we should test devise area elsewhere to make sure the process
        # is 100% reliable.

      end

      it 'tries the email challenge but it is already successful' do

        customer = FactoryGirl.create(:customer, :from_wechat, :with_valid_email)

        described_class.new(customer, '优惠券').perform
        perform = described_class.new(customer, '1').perform
        expect(perform).to eq(true)

        # the reward was auto attributed while checking the challenge
        customer.reload
        expect(customer.rewards.count).to eq(1)
        expect(customer.rewards.first.to_end?).to eq(false)

      end

      it 'goes through the invite three friends  challenge successfully' do

        described_class.new(customer, '优惠券').perform
        described_class.new(customer, '2').perform
        # should display a message saying "invite your introduced"
        expect(customer.rewards.count).to eq(1)
        expect(customer.rewards.first.to_end?).to eq(true)

        # we add the introduced virtually
        introduced.each do |user|
          user.introducer = customer
          user.save(validate: false)
        end

        # we roll the offer again and see whats up
        described_class.new(customer, '优惠券').perform
        described_class.new(customer, '2').perform

        # challenge finished
        expect(customer.rewards.first.to_end?).to eq(false)

      end

    end


  end

end
