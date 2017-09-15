describe Customer::AddressesController, type: :controller do
  render_views

  # has addresses by default
  let(:current_user) { FactoryGirl.create(:customer) }

  before(:each) do
    login_customer current_user
  end

  context '#index' do
    subject { get :index }
    it { is_expected.to have_http_status(200) }
  end

  context '#new' do
    subject { get :new }
    it { is_expected.to have_http_status(200) }
  end

  context '#edit' do
    subject { get :edit, id: current_user.addresses.first }
    it { is_expected.to have_http_status(200) }
  end

  # NOTE : this controller is uncompleted, we should test #create and #update as well

end
