describe Customer::Orders::CustomerController, type: :controller do
  render_views

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
  let(:order) { FactoryGirl.create(:order, shop: shop, user: current_user) }

  before(:each) do
    login_customer current_user
  end

  context '#show' do
    subject { get :show, order_id: order.id }
    # it redirects to the correct page afterwards
    it { is_expected.to have_http_status(302) }
  end

end
