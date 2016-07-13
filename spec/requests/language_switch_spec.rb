describe "Language switch", :type => :request  do

  context "admin on the website" do

    let(:current_user) { FactoryGirl.create(:admin) }
    before(:each) { 
      post user_session_path, :user => { :email => current_user.email, :password => '12345678' } # because it's a request, inter-controller system
      #login_customer current_user
    }

    it "set the language to german from a specific page" do

      get shops_path
      expect(response).to have_http_status(:ok)
      patch language_path("de")
      expect(session[:locale]).to eq("de")
      expect(response).to redirect_to shops_path

    end

  end
end
