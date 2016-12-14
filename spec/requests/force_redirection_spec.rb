describe "force redirection", :type => :request  do

  context "try to access admin area" do

    context "as admin" do

      let(:admin) { FactoryGirl.create(:admin) }

      it "succeeds after log-in" do

        visit admin_categories_path
        expect(current_path).to eq(new_user_session_path)
        login!(admin)
        expect(current_path).to eq(admin_categories_path)

      end

    end

    context "as shopkeeper" do
      
      let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }

      it "fails after log-in" do

        visit admin_categories_path
        expect(current_path).to eq(new_user_session_path)
        login!(shopkeeper)
        expect(current_path).not_to eq(admin_categories_path)

      end

    end

  end

end
