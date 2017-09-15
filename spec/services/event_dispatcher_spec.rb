describe EventDispatcher do

  context '#customer_signed_in' do

    subject(:subject) { described_class.new }
    let(:user) { FactoryGirl.create(:customer) }

    it 'register an a sign-in event with geo' do
      # with_geo(ip: '2003:c3:93d0:e378:74c7:b9e:ee25:9464') <- impossible to test locally
      api_call = subject.customer_signed_in(user).dispatch!
      expect(api_call).to eq({ "created" => true})
    end

  end

end
