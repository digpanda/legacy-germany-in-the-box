describe Guest::HomeController, type: :controller do
  render_views

  describe '#show' do
    it { expect { get :show }.not_to raise_error }
  end
end
