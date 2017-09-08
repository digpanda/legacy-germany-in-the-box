describe Guest::CategoriesController, type: :controller do
  render_views

  let(:category) { FactoryGirl.create(:category) }
  describe '#show' do
    context "as guest" do
      it do
        get :show, id: category
        expect(response).to render_template('show')
      end
    end

    # we test the restrict_to as well
    context "as admin" do
      let(:current_user) { FactoryGirl.create(:admin) }
      before(:each) { login_admin current_user }
      it do
        get :show, id: category
        expect(response).not_to have_http_status(200)
      end
    end
  end

end
