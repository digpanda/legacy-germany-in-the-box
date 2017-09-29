describe Guest::ServicesController, type: :controller do
  render_views

  let(:service) { FactoryGirl.create(:service) }

  describe '#show' do
    subject { get :show, id: service.id }
    it { is_expected.to have_http_status(200) }
  end

  describe '#index' do
    subject { get :index }
    it { is_expected.to have_http_status(200) }
  end
end
