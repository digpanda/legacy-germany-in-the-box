describe "language#update process", :type => :feature, :js => true  do

  context "logged-in as admin" do

      before(:each) do
        VCR.turn_off!
        WebMock.allow_net_connect!
      end

      after(:each) do
        VCR.turn_on!
        WebMock.disable_net_connect!
      end


    let(:current_user) { FactoryGirl.create(:admin) }

    it "sets the language to german from the admin shop page" do

      include Capybara::DSL

      Capybara.app_host =  "http://localhost:3000"
      Capybara.run_server = false
      Capybara.current_driver = :selenium


      binding.pry
        visit '/users/sign_in'
        fill_in 'user[email]', :with => current_user.email
        fill_in 'user[password]', :with => '12345678'
        click_button '确定'

        visit shops_path
        expect(response).to have_http_status(:ok)
        click_button '德语/DE'
        #patch language_path("de")
        expect(session[:locale]).to eq("de")
        expect(response).to redirect_to shops_path

      end

    end

=begin
  context "as guest" do

    it "sets the language to german and relocate automatically to the sign-in" do

      patch language_path("de", location: new_user_session_path)
      expect(session[:locale]).to eq("de")
      expect(response).to redirect_to new_user_session_path

    end

  end
=end
end
