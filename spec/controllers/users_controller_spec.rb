describe UsersController do

  context "listing without identification" do

    let(:user) { build :user }
    before { allow(controller).to receive(:current_user) { user } }
    let(:current_user) { user }

    it "shows the users list" do

      get :index
      expect(response).to be_success

    end

  end

end