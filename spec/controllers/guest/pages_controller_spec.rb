describe Guest::PagesController, type: :controller do
  render_views

  describe '#business_model' do
    subject { get :business_model }
    it { is_expected.to have_http_status(200) }
  end

  describe '#agb' do
    subject { get :agb }
    # we need to be authenticated
    it { is_expected.to have_http_status(302) }
  end

  describe '#privacy' do
    subject { get :privacy }
    it { is_expected.to have_http_status(200) }
  end

  describe '#imprint' do
    subject { get :imprint }
    it { is_expected.to have_http_status(200) }
  end

  describe '#saleguide' do
    subject { get :saleguide }
    it { is_expected.to have_http_status(200) }
  end

  describe '#customer_guide' do
    subject { get :customer_guide }
    it { is_expected.to have_http_status(200) }
  end

  describe '#customer_agb' do
    subject { get :customer_agb }
    it { is_expected.to have_http_status(200) }
  end

  describe '#customer_about' do
    subject { get :customer_about }
    it { is_expected.to have_http_status(200) }
  end

  describe '#customer_qa' do
    subject { get :customer_qa }
    it { is_expected.to have_http_status(200) }
  end

  describe '#shipping_cost' do
    subject { get :shipping_cost }
    it { is_expected.to have_http_status(200) }
  end

  describe '#fees' do
    subject { get :fees }
    it { is_expected.to have_http_status(200) }
  end

  describe '#publicity' do
    subject { get :publicity }
    it { is_expected.to have_http_status(200) }
  end
end
