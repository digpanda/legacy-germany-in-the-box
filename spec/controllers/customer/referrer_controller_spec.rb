describe Customer::ReferrerController, type: :controller do
  render_views

  # has addresses by default
  let(:current_user) { FactoryGirl.create(:customer, :with_referrer) }

  before(:each) do
    login_customer current_user
  end

  context '#show' do
    subject { get :show }
    it { is_expected.to have_http_status(200) }

    context 'without being referrer' do
      let(:current_user) { FactoryGirl.create(:customer) }

      before(:each) do
        login_customer current_user
      end

      subject { get :show }
      it { is_expected.to have_http_status(302) }
    end

  end

  context '#provision' do
    subject { get :provision }
    it { is_expected.to have_http_status(200) }
  end

  context '#provision_rates' do
    subject { get :provision_rates }
    it { is_expected.to have_http_status(200) }
  end

  context '#agb' do
    subject { get :agb }
    it { is_expected.to have_http_status(200) }
  end

  context '#coupons' do
    subject { get :coupons }
    it { is_expected.to have_http_status(200) }
  end

  context 'with memorized qrcode' do
    context '#qrcode' do
      subject { get :qrcode }
      it { is_expected.to have_http_status(200) }
    end

  end
  context '#claim' do
    subject { -> { patch :claim } }
    it { is_expected.not_to raise_error }
  end

end
