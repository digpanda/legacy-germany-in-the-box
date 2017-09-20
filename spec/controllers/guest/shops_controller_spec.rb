describe Guest::ShopsController, type: :controller do
  render_views

  let(:shop) { FactoryGirl.create(:shop) }
  let(:current_user) { FactoryGirl.create(:admin) }
  let(:category) { FactoryGirl.create(:category) }

  describe '#show' do

    context 'as a guest' do
      context 'without category filter' do
        subject { get :show, id: shop.id }
        it { is_expected.to have_http_status(200) }
      end

      context 'with category filter' do
        subject { get :show, id: shop.id, category_id: category.id }
        it { is_expected.to have_http_status(200) }
      end
    end

    context 'as an admin' do

      before(:each) do
        login_admin current_user
      end

      subject { get :show, id: shop.id }
      it { is_expected.to have_http_status(302) }
    end

  end

end
