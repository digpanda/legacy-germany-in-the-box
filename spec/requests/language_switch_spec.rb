describe "language#update process", :type => :request  do

=begin
  context "logged-in as admin" do

    let(:current_user) { FactoryGirl.create(:admin) }
    before(:each) { post user_session_path, :user => { :email => current_user.email, :password => '12345678' } } # because it's a request, inter-controller system

    it "sets the language to german from the admin shop page" do

      get shops_path
      expect(response).to have_http_status(:ok)
      patch language_path("de")
      expect(session[:locale]).to eq("de")
      expect(response).to redirect_to shops_path

    end

  end

  context "as guest" do

    it "sets the language to german and relocate automatically to the sign-in" do

      patch language_path("de", location: new_user_session_path)
      expect(session[:locale]).to eq("de")
      expect(response).to redirect_to new_user_session_path

    end

  end
=end
end
