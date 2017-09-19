describe Customer::CheckoutController, type: :controller do
  render_views

  # has addresses by default
  let(:current_user) { FactoryGirl.create(:customer) }
  let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
  let(:order) { FactoryGirl.create(:order, shop: shop) }

  # let(:order) { FactoryGirl.create(:order, :with_package_set) }

  before(:each) do
    login_customer current_user
  end

  context '#create' do
    context 'with valid session' do

      before(:each) do
        session[:current_checkout_order] = order
      end

      # NOTE : we should find a way to actually compare the paths
      # which is a more solid solution
      # this would also allow us to test
      # unvalid session redirects
      subject { get :create, delivery_destination_id: current_user.addresses.first }
      it { is_expected.to have_http_status(302) }

    end
  end

  context '#payment_method' do

    before(:each) do
      session[:current_checkout_order] = order
    end

    subject { get :payment_method }

    context 'with unpaid order' do
      it { is_expected.to have_http_status(200) }
    end

    context 'with paid order' do
      let(:order) { FactoryGirl.create(:order, :was_bought) }
      it { is_expected.to have_http_status(302) }
    end

  end

  context '#gateway' do

    before(:each) do
      session[:current_checkout_order] = order
      # we do not call the real API
      allow_any_instance_of(CheckoutGateway).to receive(:perform).and_return(
        # TODO : we should fake a complete checkout gateway
        # with a `page` callback once we test completely CheckoutGateway itself
        # (or at least get a valid callback from the real APi and copy it here)
        # NOTE WARNING : because wechatpay should stay on place with a qrcode
        # only alipay redirect to a `url`
        BaseService.new.return_with(:success, url: 'http://fake-url.com')
      )
    end

    context 'with wechatpay' do
      subject { get :gateway, payment_method: 'wechatpay' }
      it { is_expected.to have_http_status(302) }
    end

    context 'with alipay' do
      subject { get :gateway, payment_method: 'alipay' }
      it { is_expected.to have_http_status(302) }
    end

    context 'with invalid payment method' do
      subject { get :gateway, payment_method: 'fake' }
      it { is_expected.to have_http_status(302) }

      # TODO : refactor this into a `is_expected` with correct syntax
      it do
        get :gateway, payment_method: 'fake'
        expect(flash[:error]).not_to eq(nil)
      end
    end

  end

end
