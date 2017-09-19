describe Customer::AccountController, type: :controller do
  render_views

  let(:current_user) { FactoryGirl.create(:customer) }

  before(:each) do
    login_customer current_user
  end

  context '#menu' do
    subject { get :menu }
    it { is_expected.to have_http_status(200) }
  end

  context '#missing_info' do

    context 'has some missing informations' do

      # it only works with referrer accounts
      # the normal user can lack missing info on log-in
      let(:current_user) { FactoryGirl.create(:customer, :with_referrer, :without_name) }

      before(:each) do
        login_customer current_user
      end

      subject { get :missing_info }
      it { is_expected.to have_http_status(200) }
    end

    context 'has no missing informations' do
      subject { get :missing_info }
      it { is_expected.to have_http_status(302) }
    end
  end

end
