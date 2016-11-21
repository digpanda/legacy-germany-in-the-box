feature "visits the shops", :js => true  do

  before(:each) {
    create_ui_categories!
    FactoryGirl.create_list(:product, 20)
  }

  scenario "from the homepage" do

    visit root_path
    page.first('#food').click # click on anything
    expect(page).to have_css 'h2', text: '食品佳酿' # we are now on the food shops page
    page.first('h3').click
    binding.pry
    # click_link '德语/DE'
    # expect(page).to have_content('Sprache') # footer language switcher in German


  end

end
