describe Customer::Orders::CouponsController, type: :controller do
  render_views

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:shop) { FactoryGirl.create(:shop, :with_payment_gateways) }
  let(:order) { FactoryGirl.create(:order, shop: shop, user: current_user) }
  let(:coupon) { FactoryGirl.create(:coupon, :with_referrer) }

  before(:each) do
    login_customer current_user
  end

  context '#create' do
    it do
      get :create, order_id: order.id, coupon: { code: coupon.code }
      expect(flash[:success]).not_to eq(nil)
    end
  end

  context '#destroy' do
    let(:order) { FactoryGirl.create(:order, shop: shop, user: current_user, coupon: coupon) }
    it do
      get :destroy, order_id: order.id
      expect(flash[:error]).to eq(nil)
    end
  end

end
