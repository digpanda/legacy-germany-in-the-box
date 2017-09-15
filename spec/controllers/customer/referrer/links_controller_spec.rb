describe Customer::Referrer::LinksController, type: :controller do
  render_views

  let(:current_user) { FactoryGirl.create(:customer, :with_referrer) }
  let(:links) { FactoryGirl.create_list(:link, 5) }

  before(:each) do
    login_customer current_user
  end

  context '#index' do
    subject { get :index }
    it { is_expected.to have_http_status(200) }
  end

  context '#share' do
    subject { get :share, link_id: links.first.id }
    it { is_expected.to have_http_status(200) }
  end
end
