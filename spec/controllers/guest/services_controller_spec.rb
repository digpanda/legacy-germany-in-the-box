describe Guest::ServicesController, type: :controller do
  render_views

  let(:service) { FactoryGirl.create(:service) }

  describe '#show' do
    subject { get :show, id: service.id }
    it { is_expected.to have_http_status(200) }
  end

  context 'with a list of services' do

    before(:each) do
      FactoryGirl.create_list(:service, 5)
      FactoryGirl.create_list(:service, 3, :referrers_only)
    end

    describe '#index' do
      subject { get :index }
      it { is_expected.to have_http_status(200) }
    end

    context 'as referrer' do

      let(:current_user) { FactoryGirl.create(:customer, :with_referrer) }
      before(:each) { login_customer current_user }

      describe '#index' do
        subject { get :index }
        it { is_expected.to have_http_status(200) }
      end

    end

  end

end
