describe Guest::CategoriesController, type: :controller do
  render_views

  let(:category) { FactoryGirl.create(:category) }

  describe '#show' do

    subject { get :show, id: category }

    context "as guest" do
      it { is_expected.to render_template('show') }
    end

    # we test the restrict_to as well
    context "as admin" do
      let(:current_user) { FactoryGirl.create(:admin) }
      before(:each) { login_admin current_user }

      it { is_expected.not_to have_http_status(200) }
    end

  end

end
