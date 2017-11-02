describe WechatBot::Exchange do

  before(:each) do

    allow_any_instance_of(WechatBot::Base).to receive(:messenger).and_return(
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

    it 'sends a ping' do
      perform = described_class.new(customer, 'ping').perform
      expect(perform).to eq(true)
    end

    # we actually test the offers area with email typing
    # which is complex enough to fully crash the global exchange system
    # if buggy.
    it 'sends a set of recursive interactions' do
      described_class.new(customer, 'offers').perform
      described_class.new(customer, '1').perform

      perform = described_class.new(customer, 'wrong-email').perform
      # it didn not achieve so it goes down and try other possibilities (none are available here)
      expect(perform).to eq(false)
      # because the update we attempted we need to do that
      customer.reload
      expect(customer.email).not_to eq('wrong-email')

      # now we try again, it should pass because the memory is still on place
      perform = described_class.new(customer, 'valid-email@gmail.com').perform
      expect(perform).to eq(true)

      # because the update we attempted we need to make sure it's stored
      customer.reload
      expect(customer.email).to eq('valid-email@gmail.com')
      expect(customer.rewards.count).to eq(1)
    end
  end

end
