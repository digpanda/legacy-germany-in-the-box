describe WechatSilentLogin  do

  subject(:subject) { described_class.new(request: request, navigation: navigation, cart_manager: cart_manager, code: code) }
  let(:navigation) { NavigationHistory.new(request, request.session) }
  let(:cart_manager) { CartManager.new(request, user) }
  let(:user) { FactoryGirl.create(:customer, :from_wechat) }
  let(:request) { fake_request }
  let(:code) { 'fake-code' }

  before(:each) do
    # we cant stub properly devise outside of a controller
    allow_any_instance_of(described_class).to receive(:signin!).and_return(nil)
  end

  context '#connect!' do

    it 'signin the user' do
      allow_any_instance_of(described_class).to receive(:wechat_api_connect_solver).and_return(
        BaseService.new.return_with(:success, customer: user)
      )
      resolved = subject.connect!
      expect(resolved).to eq(true)
    end

    it "fails to signin the user" do
      allow_any_instance_of(described_class).to receive(:wechat_api_connect_solver).and_return(
        BaseService.new.return_with(:error, "Fake error")
      )
      resolved = subject.connect!
      expect(resolved).to eq(false)
    end

  end

  context '#redirect' do
    it "signin and redirects" do

    allow_any_instance_of(described_class).to receive(:wechat_api_connect_solver).and_return(
      BaseService.new.return_with(:success, customer: user)
    )
    subject.connect!

    # NOTE : this could be improved when we improve the navigation stub
    expect(subject.redirect).to eq('/')

    end
  end

end
