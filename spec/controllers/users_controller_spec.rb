describe UsersController do

  context "listing without authentification (API)" do

    let(:user) { build :user }
    before { allow(controller).to receive(:current_user) { user } }
    let(:current_user) { user }

    it "shows the users list" do # check with the TECH GUY what it should do here

      get :index, :format => :json
      expect(response).to be_success

    end

  end

  context "user actions with authentificatio (API)" do

    let(:user) { build :user }
    before { allow(controller).to receive(:current_user) { user } }
    let(:current_user) { user }

    it "show a specific user to another user" do

      binding.pry
      get :show, :id => FactoryGirl.create(:user, email: 'random@random.com', username: 'another').id, :format => :json

    end

  end

end