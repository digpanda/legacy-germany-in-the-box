describe WechatSilentLogin  do

  context '#connect!' do

    include Devise::TestHelpers

    subject(:subject) { described_class.new(request: request, navigation: navigation, cart_manager: cart_manager, code: code) }

    let(:navigation) { NavigationHistory.new(request, request.session) }
    let(:cart_manager) { CartManager.new(request, user) }
    let(:user) { FactoryGirl.create(:customer, :from_wechat) }
    let(:request) { double('request', original_url: 'http://test.com', session: {}, params: {}, env: {'warden': nil}) }
    let(:code) { 'fake-code' }

    it 'signin the user' do

      allow(request.env['warden'])
         .to receive(:authenticate!)
         .and_throw(:warden, {:scope => :user})
       # we emulate the user signin to make devise work clean with the library
      @request = request
      login_customer(user)

      allow_any_instance_of(described_class).to receive(:wechat_api_connect_solver).and_return(
        BaseService.new.return_with(:success, customer: user)
      )

      resolved = subject.connect!

      binding.pry
      expect(user).to eq(current_user)

    end

  end

  context 'redirect' do
  end

end
