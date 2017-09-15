describe Guest::SearchController, type: :controller do
  render_views

  describe '#show' do
    context 'without query' do
      subject { get :show }
      it { is_expected.to have_http_status(200) }
    end

    context 'with query' do
      subject { get :show, query: 'fake product search' }
      it { is_expected.to have_http_status(200) }
    end
  end

end
