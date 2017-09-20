describe Customer::Orders::AddressesController, type: :controller, vcr: { record: :skip } do
  render_views

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
  let(:order) { FactoryGirl.create(:order, shop: shop, user: current_user) }

  before(:each) do
    login_customer current_user
  end

  context '#index' do
    subject { get :index, order_id: order.id }
    it { is_expected.to redirect_to(new_customer_order_address_path(order)) }

    context 'without valid order' do
      subject { get :index, order_id: 'fake-order' }
      it { is_expected.to have_http_status(404) }
    end

  end

  context '#new' do
    subject { get :new, order_id: order.id }
    it { is_expected.to have_http_status(200) }
  end

end
