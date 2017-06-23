feature "language#update process", :js => true  do

  context "logged-in as admin" do

    let(:admin) { FactoryGirl.create(:admin) }

    # scenario "click in switch language button from chinese to german after login" do
    #
    #   visit new_user_session_path
    #   fill_in 'user[email]', :with => admin.email
    #   fill_in 'user[password]', :with => '12345678'
    #   page.first("#sign_in").trigger('click')
    #   expect(page).to have_content('语言') # footer language switcher in Chinese
    #   click_link '德语/DE'
    #   expect(page).to have_content('Sprache') # footer language switcher in German
    #
    # end

  end

  context "as guest" do

    # NOTE : doesn't exist anymore
    # - Laurent, 24/01/2017
    # scenario "switch from customer to shopkeeper site and change language automatically" do
    #
    #   visit root_path
    #   expect(page).to have_content('来因盒') # Germany in the Box (in Chinese)
    #   click_link 'Partner-Hersteller Werden'
    #   expect(page).to have_content('Möchten Sie etwas kaufen?') # We are on the shopkeeper site
    #
    # end

  end

end
