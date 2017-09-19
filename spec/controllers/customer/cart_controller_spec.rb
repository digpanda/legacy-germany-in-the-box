describe Customer::CartController, type: :controller do
  render_views

  # has addresses by default
  let(:current_user) { FactoryGirl.create(:customer) }

  # NOTE : we should make a helper for global requests rather
  # than making doubles in each spec file
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:cart_manager) { CartManager.new(request, current_user) }

  before(:each) do
    login_customer current_user
    fill_cart_manager!(cart_manager)
  end

  context '#show' do
    subject { get :show }
    it { is_expected.to have_http_status(200) }
  end

end
