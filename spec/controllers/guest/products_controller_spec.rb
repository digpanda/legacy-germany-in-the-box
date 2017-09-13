describe Guest::ProductsController, type: :controller do
  render_views

  let(:product) { FactoryGirl.create(:product) }

  describe '#show' do
    subject { get :show, id: product.id }
    it { is_expected.to have_http_status(200) }
  end

end
