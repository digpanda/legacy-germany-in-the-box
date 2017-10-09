describe EventDispatcher do

  context '#customer_signed_in' do

    subject(:subject) { described_class.new }
    let(:user) { FactoryGirl.create(:customer) }

    it 'register an a sign-in event with geo' do
      api_call = subject.customer_signed_in(user).dispatch!
      expect(api_call).to eq('created' => true)
    end

  end

end
