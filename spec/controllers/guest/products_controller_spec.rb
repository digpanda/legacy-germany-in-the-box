describe Guest::ProductsController, type: :controller do
  render_views

  let(:product) { FactoryGirl.create(:product) }
  let(:current_user) { FactoryGirl.create(:admin) }

  describe '#show' do

    context "as a guest" do
      subject { get :show, id: product.id }
      it { is_expected.to have_http_status(200) }
    end

    context "as an admin" do

      before(:each) do
        login_admin current_user
      end

      subject { get :show, id: product.id }
      it { is_expected.to have_http_status(302) }
    end

  end

end
