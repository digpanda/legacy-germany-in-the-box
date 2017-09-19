describe Guest::ShopApplicationsController, type: :controller do
  render_views

  # NOTE : the test of this controller is extremely partial
  # because we don't know if we will actually keep it
  describe '#new' do
    subject { get :new }
    it { is_expected.to have_http_status(200) }
  end

end
