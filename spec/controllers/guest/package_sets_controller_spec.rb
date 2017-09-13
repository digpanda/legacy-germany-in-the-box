describe Guest::PackageSetsController, type: :controller do
  render_views

  let(:package_set) { FactoryGirl.create(:package_set) }
  let(:category_filter) { package_set.package_skus.first.product.categories.first }
  let(:brand_filter) { package_set.package_skus.first.product.brand }

  describe '#show' do
    subject { get :show, id: package_set.id }
    it { is_expected.to have_http_status(200) }
  end

  describe '#categories' do
    subject { get :categories }
    it { is_expected.to have_http_status(200) }
  end

  describe '#index' do
    subject { get :index }
    it { is_expected.to redirect_to(guest_package_sets_categories_path) }

    context 'with a category filter' do
      subject { get :index, category_id: category_filter.id }
      it { is_expected.to have_http_status(200) }

      context 'invalid category' do
        subject { get :index, category_id: 'fake-category' }
        it { is_expected.to redirect_to(guest_package_sets_categories_path) }
      end

    end

    context 'with a brand filter' do
      subject { get :index, brand_id: brand_filter.id }
      it { is_expected.to have_http_status(200) }

      context 'invalid brand' do
        subject { get :index, brand_id: 'fake-brand' }
        it { is_expected.to redirect_to(guest_package_sets_categories_path) }
      end

    end

  end

end
